<!-- BEGIN_TF_DOCS -->
# Scaffolding Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "nxos_scaffolding" {
  source  = "netascode/scaffolding/nxos"
  version = ">= 0.0.1"

  id          = "eth1/10"
  description = "My Description"
  mode        = "trunk"
}
```
<!-- END_TF_DOCS -->