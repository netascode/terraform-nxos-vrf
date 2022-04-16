<!-- BEGIN_TF_DOCS -->
# NX-OS VRF Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "nxos_vrf" {
  source  = "netascode/vrf/nxos"
  version = ">= 0.0.1"

  name                = "VRF1"
  description         = "My Description"
  vni                 = 16777210
  route_distinguisher = "1.1.1.1:1"
  address_family = {
    ipv4_unicast = {
      route_target_both_auto      = true
      route_target_both_auto_evpn = true
      route_target_import         = ["1.1.1.1:1", "65535:1", "65536:123"]
      route_target_export         = ["1.1.1.1:1", "65535:1", "65536:123"]
      route_target_import_evpn    = ["2.2.2.2:2", "65000:1", "100000:123"]
      route_target_export_evpn    = ["2.2.2.2:2", "65000:1", "100000:123"]
    }
    ipv6_unicast = {}
  }
}
```
<!-- END_TF_DOCS -->