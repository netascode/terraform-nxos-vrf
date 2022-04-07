module "nxos_scaffolding" {
  source  = "netascode/scaffolding/nxos"
  version = ">= 0.0.1"

  id          = "eth1/10"
  description = "My Description"
  mode        = "trunk"
}
