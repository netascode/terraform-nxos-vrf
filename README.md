<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-nxos-scaffolding/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-nxos-scaffolding/actions/workflows/test.yml)

# Terraform NXOS Scaffolding Module

Description

Model Documentation: [Link](https://developer.cisco.com/docs/cisco-nexus-3000-and-9000-series-nx-api-rest-sdk-user-guide-and-api-reference-release-9-3x/#!configuring-an-ethernet-interface)

## Examples

```hcl
module "nxos_scaffolding" {
  source  = "netascode/scaffolding/nxos"
  version = ">= 0.0.1"

  id          = "eth1/10"
  description = "My Description"
  mode        = "trunk"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_nxos"></a> [nxos](#requirement\_nxos) | >= 0.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nxos"></a> [nxos](#provider\_nxos) | >= 0.1.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_id"></a> [id](#input\_id) | Interface ID. Must match first field in the output of `show intf brief`. Example: `eth1/1`. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Interface description. | `string` | `""` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | Interface mode. Choices: `access`, `trunk`, `fex-fabric`, `dot1q-tunnel`, `promiscuous`, `host`, `trunk_secondary`, `trunk_promiscuous`, `vntag`. | `string` | `"access"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `l1PhysIf` object. |
| <a name="output_id"></a> [id](#output\_id) | Interface ID. |

## Resources

| Name | Type |
|------|------|
| [nxos_rest.l1PhysIf](https://registry.terraform.io/providers/netascode/nxos/latest/docs/resources/rest) | resource |
<!-- END_TF_DOCS -->