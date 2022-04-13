# variable "id" {
#   description = "Interface ID. Must match first field in the output of `show intf brief`. Example: `eth1/1`."
#   type        = string
# }

# variable "description" {
#   description = "Interface description."
#   type        = string
#   default     = ""

#   validation {
#     condition     = can(regex("^.{0,254}$", var.description))
#     error_message = " Maximum characters: 254."
#   }
# }

# variable "mode" {
#   description = "Interface mode. Choices: `access`, `trunk`, `fex-fabric`, `dot1q-tunnel`, `promiscuous`, `host`, `trunk_secondary`, `trunk_promiscuous`, `vntag`."
#   type        = string
#   default     = "access"

#   validation {
#     condition     = contains(["access", "trunk", "fex-fabric", "dot1q-tunnel", "promiscuous", "host", "trunk_secondary", "trunk_promiscuous", "vntag"], var.mode)
#     error_message = "Valid values are `access`, `trunk`, `fex-fabric`, `dot1q-tunnel`, `promiscuous`, `host`, `trunk_secondary`, `trunk_promiscuous` or `vntag`."
#   }
# }
variable "name" {
  description = "VRF Name"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 32."
  }
}

variable "description" {
  description = "VRF description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^.{0,254}$", var.description))
    error_message = "Maximum characters: 254."
  }
}

variable "vni" {
  description = "VRF VNI"
  type        = number
  default     = null

  validation {
    condition     = var.vni == null || try(var.vni >= 1 && var.vni <= 16777214, false)
    error_message = "Minimum value: 1. Maximum value: 16777214."
  }
}

variable "route_distinguisher" {
  description = "VRF Route Distinguisher"
  type        = string
  default     = null

  validation {
    condition = "auto" == var.route_distinguisher || can(regex("\\d+\\.\\d+\\.\\d+\\.\\d+:\\d+", var.route_distinguisher)) || can(regex("\\d+:\\d+", var.route_distinguisher)
    error_message = "Allowed formats: `auto`, `1.1.1.1:1`, `65535:1`."
  }
}

variable "address_family" {
  description = "VRF Address Families"
  type = map(object({
    route_target_both_auto      = optional(bool)
    route_target_both_auto_evpn = optional(bool)
    route_target_import         = optional(list(string))
    route_target_export         = optional(list(string))
    route_target_import_evpn    = optional(list(string))
    route_target_export_evpn    = optional(list(string))
  }))
  # default = {
  #   "ipv4_unicast" = {
  #     "route_target_both_auto"      = true
  #     "route_target_both_auto_evpn" = true
  #     "route_target_import"         = ["1.1.1.1:1", "65535:1", "65536:123"]
  #     "route_target_export"         = ["1.1.1.1:1", "65535:1", "65536:123"]
  #     "route_target_import_evpn"    = ["2.2.2.2:2", "65000:1", "100000:123"]
  #     "route_target_export_evpn"    = ["2.2.2.2:2", "65000:1", "100000:123"]
  #   }
  #   "ipv6_unicast" = {}
  # }
  default = {}
}

