locals {
  rd_none = var.route_distinguisher == null ? true : false
  rd_auto = var.route_distinguisher == "auto" ? true : false
  rd_ipv4 = can(regex("\\.", var.route_distinguisher)) ? true : false
  rd_as2  = !can(regex("\\.", var.route_distinguisher)) && can(regex(":", var.route_distinguisher)) ? (tonumber(split(":", var.route_distinguisher)[0]) <= 65535 ? true : false) : false
  rd_as4  = !can(regex("\\.", var.route_distinguisher)) && can(regex(":", var.route_distinguisher)) ? (tonumber(split(":", var.route_distinguisher)[0]) >= 65536 ? true : false) : false
  rd_dme_format = local.rd_none ? "unknown:unknown:0:0" : (
    local.rd_auto ? "rd:unknown:0:0" : (
      local.rd_ipv4 ? "rd:ipv4-nn2:${var.route_distinguisher}" : (
        local.rd_as2 ? "rd:as2-nn2:${var.route_distinguisher}" : (
          local.rd_as4 ? "rd:as4-nn2:${var.route_distinguisher}" : "unexpected_rd_format"
  ))))

  address_family_names_map = {
    "ipv4_unicast" : "ipv4-ucast"
    "ipv6_unicast" : "ipv6-ucast"
  }
  # set default values for the map
  # change map key
  address_family_with_defaults = {
    for key, value in var.address_family : local.address_family_names_map[key] => {
      "route_target_both_auto"      = value.route_target_both_auto != null ? value.route_target_both_auto : false
      "route_target_both_auto_evpn" = value.route_target_both_auto_evpn != null ? value.route_target_both_auto_evpn : false
      "route_target_import"         = value.route_target_import != null ? value.route_target_import : []
      "route_target_export"         = value.route_target_export != null ? value.route_target_export : []
      "route_target_import_evpn"    = value.route_target_import_evpn != null ? value.route_target_import_evpn : []
      "route_target_export_evpn"    = value.route_target_export_evpn != null ? value.route_target_export_evpn : []
    }
  }

  # add RT "auto" to import/export lists
  address_family_raw = {
    for key, value in local.address_family_with_defaults : key => {
      "route_target_import_list_raw"      = value.route_target_both_auto ? concat(["auto"], value.route_target_import) : value.route_target_import
      "route_target_export_list_raw"      = value.route_target_both_auto ? concat(["auto"], value.route_target_export) : value.route_target_export
      "route_target_import_list_evpn_raw" = value.route_target_both_auto_evpn ? concat(["auto"], value.route_target_import_evpn) : value.route_target_import_evpn
      "route_target_export_list_evpn_raw" = value.route_target_both_auto_evpn ? concat(["auto"], value.route_target_export_evpn) : value.route_target_export_evpn
    }
  }

  address_family_flat_all = flatten([
    for key, value in local.address_family_raw : [
      {
        "direction"         = "import"
        "address_family"    = key
        "address_family_rt" = key
        "rt_set"            = toset(value.route_target_import_list_raw)
      },
      {
        "direction"         = "export"
        "address_family"    = key
        "address_family_rt" = key
        "rt_set"            = toset(value.route_target_export_list_raw)
      },
      {
        "direction"         = "import"
        "address_family"    = key
        "address_family_rt" = "l2vpn-evpn"
        "rt_set"            = toset(value.route_target_import_list_evpn_raw)
      },
      {
        "direction"         = "export"
        "address_family"    = key
        "address_family_rt" = "l2vpn-evpn"
        "rt_set"            = toset(value.route_target_export_list_evpn_raw)
      }
    ]
  ])

  # filter only import/export lists with length > 0
  # loop for resource "nxos_vrf_route_target_direction"
  address_family_map = {
    for entry in local.address_family_flat_all :
    "${entry.address_family}_${entry.address_family_rt}_${entry.direction}" => entry if length(entry.rt_set) > 0
  }

  # Route Target converter from CLI format to DME format
  rt_helper = {
    for k, v in local.address_family_map : k => [
      for value in v.rt_set : {
        "format_auto" = value == "auto" ? true : false
        "format_ipv4" = can(regex("\\.", value)) ? true : false
        "format_as2"  = !can(regex("\\.", value)) && can(regex(":", value)) ? (tonumber(split(":", value)[0]) <= 65535 ? true : false) : false
        "format_as4"  = !can(regex("\\.", value)) && can(regex(":", value)) ? (tonumber(split(":", value)[0]) >= 65536 ? true : false) : false
        "value"       = value
      }
    ]
  }
  rt_dme_format_map = {
    for k, v in local.rt_helper : k => [
      for entry in v :
      entry.format_auto ? "route-target:unknown:0:0" : (
        entry.format_ipv4 ? "route-target:ipv4-nn2:${entry.value}" : (
          entry.format_as2 ? "route-target:as2-nn2:${entry.value}" : (
            entry.format_as4 ? "route-target:as4-nn2:${entry.value}" : "unexpected_rt_format"
      )))
    ]
  }

  # Add DME formatted list of RT to the address_family_map
  address_family_map_dme = {
    for key, value in local.address_family_map : key => merge(value, { "rt_dme_format" : local.rt_dme_format_map[key] })
  }

  # loop for resource "nxos_vrf_route_target"
  address_family_flat_dme = {
    for entry in flatten([
      for key, value in local.address_family_map_dme : [
        for rt in value.rt_dme_format : {
          "address_family"    = value.address_family
          "address_family_rt" = value.address_family_rt
          "direction"         = value.direction
          "rt"                = rt
          "key"               = "${key}_${rt}"
        }
      ]
  ]) : entry.key => entry }
}

resource "nxos_vrf" "l3Inst" {
  name        = var.name
  description = var.description
  encap       = var.vni != null ? "vxlan-${var.vni}" : "unknown"
}

resource "nxos_vrf_routing" "rtctrlDom" {
  vrf                 = var.name
  route_distinguisher = local.rd_dme_format
  depends_on = [
    nxos_vrf.l3Inst
  ]
}

resource "nxos_vrf_address_family" "rtctrlDomAf" {
  for_each       = local.address_family_with_defaults
  vrf            = var.name
  address_family = each.key
  depends_on = [
    nxos_vrf_routing.rtctrlDom
  ]
}

resource "nxos_vrf_route_target_address_family" "rtctrlAfCtrl" {
  for_each = {
    for entry in toset([for i in local.address_family_map : "${i.address_family}_${i.address_family_rt}"]) : entry => {
      "address_family"    = split("_", entry)[0]
      "address_family_rt" = split("_", entry)[1]
    }
  }
  vrf                         = var.name
  address_family              = each.value.address_family
  route_target_address_family = each.value.address_family_rt
  depends_on = [
    nxos_vrf_address_family.rtctrlDomAf
  ]
}

resource "nxos_vrf_route_target_direction" "rtctrlRttP" {
  for_each                    = local.address_family_map
  vrf                         = var.name
  address_family              = each.value.address_family
  route_target_address_family = each.value.address_family_rt
  direction                   = each.value.direction
  depends_on = [
    nxos_vrf_route_target_address_family.rtctrlAfCtrl
  ]
}

resource "nxos_vrf_route_target" "rtctrlRttEntry" {
  for_each                    = local.address_family_flat_dme
  vrf                         = var.name
  address_family              = each.value.address_family
  route_target_address_family = each.value.address_family_rt
  direction                   = each.value.direction
  route_target                = each.value.rt
  depends_on = [
    nxos_vrf_route_target_direction.rtctrlRttP
  ]
}

resource "nxos_ipv4_vrf" "ipv4Dom" {
  name = var.name
}
