terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    nxos = {
      source  = "netascode/nxos"
      version = ">=0.3.3"
    }
  }
}

module "main" {
  source = "../.."

  name = "VRF1"
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
    want        = ""
  }

  equal "encap" {
    description = "encap"
    got         = data.nxos_rest.nxos_vrf.content.encap
    want        = "unknown"
  }
}
