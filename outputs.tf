output "dn" {
  value       = var.name == "default" ? "sys/inst-${var.name}" : nxos_vrf.l3Inst[0].id
  description = "Distinguished name of the object."
}

output "name" {
  value       = var.name == "default" ? var.name : nxos_vrf.l3Inst[0].name
  description = "VRF name."
}
