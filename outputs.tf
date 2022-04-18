output "dn" {
  value       = "sys/inst-${var.name}"
  description = "Distinguished name of the object."
}

output "name" {
  value       = var.name
  description = "VRF name."
}
