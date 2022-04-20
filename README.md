<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-nxos-vrf/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-nxos-vrf/actions/workflows/test.yml)

# Terraform NX-OS VRF Module

Manages NX-OS VRF

Model Documentation: [Link](https://developer.cisco.com/docs/cisco-nexus-3000-and-9000-series-nx-api-rest-sdk-user-guide-and-api-reference-release-9-3x/#!configuring-vrfs)

## Examples

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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_nxos"></a> [nxos](#requirement\_nxos) | >= 0.3.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nxos"></a> [nxos](#provider\_nxos) | 0.3.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | VRF Name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | VRF description. | `string` | `""` | no |
| <a name="input_vni"></a> [vni](#input\_vni) | VRF Virtual Network Identifier. | `number` | `null` | no |
| <a name="input_route_distinguisher"></a> [route\_distinguisher](#input\_route\_distinguisher) | VRF Route Distinguisher. | `string` | `null` | no |
| <a name="input_address_family"></a> [address\_family](#input\_address\_family) | VRF Address Families. Valid values of map keys are `ipv4_unicast`, `ipv6_unicast`. | <pre>map(object({<br>    route_target_both_auto      = optional(bool)<br>    route_target_both_auto_evpn = optional(bool)<br>    route_target_import         = optional(list(string))<br>    route_target_export         = optional(list(string))<br>    route_target_import_evpn    = optional(list(string))<br>    route_target_export_evpn    = optional(list(string))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of the object. |
| <a name="output_name"></a> [name](#output\_name) | VRF name. |

## Resources

| Name | Type |
|------|------|
| [nxos_ipv4_vrf.ipv4Dom](https://registry.terraform.io/providers/netascode/nxos/latest/docs/resources/ipv4_vrf) | resource |
| [nxos_vrf.l3Inst](https://registry.terraform.io/providers/netascode/nxos/latest/docs/resources/vrf) | resource |
| [nxos_vrf_address_family.rtctrlDomAf](https://registry.terraform.io/providers/netascode/nxos/latest/docs/resources/vrf_address_family) | resource |
| [nxos_vrf_route_target.rtctrlRttEntry](https://registry.terraform.io/providers/netascode/nxos/latest/docs/resources/vrf_route_target) | resource |
| [nxos_vrf_route_target_address_family.rtctrlAfCtrl](https://registry.terraform.io/providers/netascode/nxos/latest/docs/resources/vrf_route_target_address_family) | resource |
| [nxos_vrf_route_target_direction.rtctrlRttP](https://registry.terraform.io/providers/netascode/nxos/latest/docs/resources/vrf_route_target_direction) | resource |
| [nxos_vrf_routing.rtctrlDom](https://registry.terraform.io/providers/netascode/nxos/latest/docs/resources/vrf_routing) | resource |
<!-- END_TF_DOCS -->