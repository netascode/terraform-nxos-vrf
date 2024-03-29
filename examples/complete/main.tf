module "nxos_vrf" {
  source  = "netascode/vrf/nxos"
  version = ">= 0.2.0"

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
}
