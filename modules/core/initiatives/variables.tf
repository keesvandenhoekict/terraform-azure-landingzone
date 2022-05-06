variable "initiatives" {
  type = map(object({
    name         = string
    display_name = string
    policies = map(object({
      name             = string
      is_custom        = bool
      management_group = string
    }))
    management_group = string
  }))
}

variable "management_groups" {
  type        = map(string)
  description = "map of management group key to group id"
  default     = {}
}
