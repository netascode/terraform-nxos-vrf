terraform {
  required_version = ">= 1.3.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    nxos = {
      source  = "CiscoDevNet/nxos"
      version = ">= 0.5.0"
    }
  }
}

# requirement
resource "nxos_feature_bgp" "bgp" {
  admin_state = "enabled"
}

resource "nxos_feature_evpn" "evpn" {
  admin_state = "enabled"
}

module "main" {
  source = "../.."

  name                = "VRF1"
  description         = "My Description"
  vni                 = 16777210
  route_distinguisher = "1.1.1.1:1"
  address_families = [
    {
      address_family              = "ipv4_unicast"
      route_target_both_auto      = true
      route_target_both_auto_evpn = true
      route_target_import         = ["1.1.1.1:1", "65535:1", "65536:123"]
      route_target_export         = ["1.1.1.1:1", "65535:1", "65536:123"]
      route_target_import_evpn    = ["2.2.2.2:2", "65000:1", "100000:123"]
      route_target_export_evpn    = ["2.2.2.2:2", "65000:1", "100000:123"]
    },
    {
      address_family = "ipv6_unicast"
    }
  ]
  depends_on = [
    nxos_feature_bgp.bgp,
    nxos_feature_evpn.evpn
  ]
}

data "nxos_rest" "nxos_vrf" {
  dn = "sys/inst-[VRF1]"

  depends_on = [module.main]
}

resource "test_assertions" "nxos_vrf" {
  component = "nxos_vrf"

  equal "name" {
    description = "name"
    got         = data.nxos_rest.nxos_vrf.content.name
    want        = "VRF1"
  }

  equal "descr" {
    description = "descr"
    got         = data.nxos_rest.nxos_vrf.content.descr
    want        = "My Description"
  }

  equal "encap" {
    description = "encap"
    got         = data.nxos_rest.nxos_vrf.content.encap
    want        = "vxlan-16777210"
  }
}

data "nxos_rest" "nxos_vrf_routing" {
  dn = "sys/inst-[VRF1]/dom-[VRF1]"

  depends_on = [module.main]
}

resource "test_assertions" "nxos_vrf_routing" {
  component = "nxos_vrf_routing"

  equal "rd" {
    description = "rd"
    got         = data.nxos_rest.nxos_vrf_routing.content.rd
    want        = "rd:ipv4-nn2:1.1.1.1:1"
  }
}

data "nxos_rest" "nxos_vrf_address_family" {
  dn = "sys/inst-[VRF1]/dom-[VRF1]/af-[ipv4-ucast]"

  depends_on = [module.main]
}

resource "test_assertions" "nxos_vrf_address_family" {
  component = "nxos_vrf_address_family"

  equal "type" {
    description = "type"
    got         = data.nxos_rest.nxos_vrf_address_family.content.type
    want        = "ipv4-ucast"
  }
}

data "nxos_rest" "nxos_vrf_route_target_address_family_ipv4" {
  dn = "sys/inst-[VRF1]/dom-[VRF1]/af-[ipv4-ucast]/ctrl-[ipv4-ucast]"

  depends_on = [module.main]
}

data "nxos_rest" "nxos_vrf_route_target_address_family_evpn" {
  dn = "sys/inst-[VRF1]/dom-[VRF1]/af-[ipv4-ucast]/ctrl-[l2vpn-evpn]"

  depends_on = [module.main]
}

resource "test_assertions" "nxos_vrf_route_target_address_family" {
  component = "nxos_vrf_route_target_address_family"

  equal "type-ipv4-ucast" {
    description = "type-ipv4-ucast"
    got         = data.nxos_rest.nxos_vrf_route_target_address_family_ipv4.content.type
    want        = "ipv4-ucast"
  }

  equal "type-l2vpn-evpn" {
    description = "type-l2vpn-evpn"
    got         = data.nxos_rest.nxos_vrf_route_target_address_family_evpn.content.type
    want        = "l2vpn-evpn"
  }
}

data "nxos_rest" "nxos_vrf_route_target_direction" {
  dn = "sys/inst-[VRF1]/dom-[VRF1]/af-[ipv4-ucast]/ctrl-[l2vpn-evpn]/rttp-[import]"

  depends_on = [module.main]
}

resource "test_assertions" "nxos_vrf_route_target_direction" {
  component = "nxos_vrf_route_target_direction"

  equal "type" {
    description = "type"
    got         = data.nxos_rest.nxos_vrf_route_target_direction.content.type
    want        = "import"
  }
}

data "nxos_rest" "nxos_vrf_route_target" {
  dn = "sys/inst-[VRF1]/dom-[VRF1]/af-[ipv4-ucast]/ctrl-[l2vpn-evpn]/rttp-[import]/ent-[route-target:as2-nn2:65000:1]"

  depends_on = [module.main]
}

resource "test_assertions" "nxos_vrf_route_target" {
  component = "nxos_vrf_route_target"

  equal "rtt" {
    description = "rtt"
    got         = data.nxos_rest.nxos_vrf_route_target.content.rtt
    want        = "route-target:as2-nn2:65000:1"
  }
}

