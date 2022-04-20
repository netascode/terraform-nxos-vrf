variable "name" {
  description = "VRF Name."
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
    error_message = "Maximum characters: `254`."
  }
}

variable "vni" {
  description = "VRF Virtual Network Identifier."
  type        = number
  default     = null

  validation {
    condition     = var.vni == null || try(var.vni >= 1 && var.vni <= 16777214, false)
    error_message = "Minimum value: `1`. Maximum value: `16777214`."
  }
}

variable "route_distinguisher" {
  description = "VRF Route Distinguisher."
  type        = string
  default     = null

  validation {
    condition     = var.route_distinguisher == null || var.route_distinguisher == "auto" || can(regex("\\d+\\.\\d+\\.\\d+\\.\\d+:\\d+", var.route_distinguisher)) || can(regex("\\d+:\\d+", var.route_distinguisher))
    error_message = "Allowed formats: `auto`, `1.1.1.1:1`, `65535:1`."
  }
}

variable "address_family" {
  description = "VRF Address Families. Valid values of map keys are `ipv4_unicast`, `ipv6_unicast`."
  type = map(object({
    route_target_both_auto      = optional(bool)
    route_target_both_auto_evpn = optional(bool)
    route_target_import         = optional(list(string))
    route_target_export         = optional(list(string))
    route_target_import_evpn    = optional(list(string))
    route_target_export_evpn    = optional(list(string))
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.address_family : contains(["ipv4_unicast", "ipv6_unicast"], k)
    ])
    error_message = "`address_family`: Valid values of map keys are `ipv4_unicast`, `ipv6_unicast`."
  }

  validation {
    condition = alltrue(flatten([
      for k, v in var.address_family : v.route_target_import == null ? [true] : [
        for entry in v.route_target_import : entry == "auto" || can(regex("\\d+\\.\\d+\\.\\d+\\.\\d+:\\d+", entry)) || can(regex("\\d+:\\d+", entry))
      ]
    ]))
    error_message = "`route_target_import`: Allowed formats: `auto`, `1.1.1.1:1`, `65535:1`."
  }

  validation {
    condition = alltrue(flatten([
      for k, v in var.address_family : v.route_target_export == null ? [true] : [
        for entry in v.route_target_export : entry == "auto" || can(regex("\\d+\\.\\d+\\.\\d+\\.\\d+:\\d+", entry)) || can(regex("\\d+:\\d+", entry))
      ]
    ]))
    error_message = "`route_target_export`: Allowed formats: `auto`, `1.1.1.1:1`, `65535:1`."
  }

  validation {
    condition = alltrue(flatten([
      for k, v in var.address_family : v.route_target_import_evpn == null ? [true] : [
        for entry in v.route_target_import_evpn : entry == "auto" || can(regex("\\d+\\.\\d+\\.\\d+\\.\\d+:\\d+", entry)) || can(regex("\\d+:\\d+", entry))
      ]
    ]))
    error_message = "`route_target_import_evpn`: Allowed formats: `auto`, `1.1.1.1:1`, `65535:1`."
  }

  validation {
    condition = alltrue(flatten([
      for k, v in var.address_family : v.route_target_export_evpn == null ? [true] : [
        for entry in v.route_target_export_evpn : entry == "auto" || can(regex("\\d+\\.\\d+\\.\\d+\\.\\d+:\\d+", entry)) || can(regex("\\d+:\\d+", entry))
      ]
    ]))
    error_message = "`route_target_export_evpn`: Allowed formats: `auto`, `1.1.1.1:1`, `65535:1`."
  }
}

