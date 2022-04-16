output "dn" {
  value       = nxos_vrf.l3Inst.id
  description = "Distinguished name of the object."
}

output "name" {
  value       = nxos_vrf.l3Inst.name
  description = "VRF name."
}
