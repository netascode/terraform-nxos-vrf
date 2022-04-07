terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    nxos = {
      source  = "netascode/nxos"
      version = ">=0.1.0"
    }
  }
}

module "main" {
  source = "../.."

  id          = "eth1/10"
  description = "My Description"
  mode        = "trunk"
}

data "nxos_rest" "l1PhysIf" {
  dn = "sys/intf/phys-[eth1/10]"

  depends_on = [module.main]
}

resource "test_assertions" "l1PhysIf" {
  component = "l1PhysIf"

  equal "id" {
    description = "id"
    got         = data.nxos_rest.l1PhysIf.content.id
    want        = "eth1/10"
  }

  equal "descr" {
    description = "descr"
    got         = data.nxos_rest.l1PhysIf.content.descr
    want        = "My Description"
  }

  equal "mode" {
    description = "mode"
    got         = data.nxos_rest.l1PhysIf.content.mode
    want        = "trunk"
  }
}
