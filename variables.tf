variable "id" {
  description = "Interface ID. Must match first field in the output of `show intf brief`. Example: `eth1/1`."
  type        = string
}

variable "description" {
  description = "Interface description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^.{0,254}$", var.description))
    error_message = " Maximum characters: 254."
  }
}

variable "mode" {
  description = "Interface mode. Choices: `access`, `trunk`, `fex-fabric`, `dot1q-tunnel`, `promiscuous`, `host`, `trunk_secondary`, `trunk_promiscuous`, `vntag`."
  type        = string
  default     = "access"

  validation {
    condition     = contains(["access", "trunk", "fex-fabric", "dot1q-tunnel", "promiscuous", "host", "trunk_secondary", "trunk_promiscuous", "vntag"], var.mode)
    error_message = "Valid values are `access`, `trunk`, `fex-fabric`, `dot1q-tunnel`, `promiscuous`, `host`, `trunk_secondary`, `trunk_promiscuous` or `vntag`."
  }
}
