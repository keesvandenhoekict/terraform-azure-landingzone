variable "parent_management_group_display_name" {
  type    = string
  default = "Tenant Root Group"
  description = "The name of the existing management group underneath which the management groups will be created"
}

variable "management_groups" {
  type = map(object({
    level        = number
    display_name = string
    parent       = string
  }))
  description = "All management groups of the landing zone, level from toplevel (0) counting up, max 4 levels"
}
