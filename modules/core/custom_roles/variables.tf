variable "custom_roles" {
  type = map(object({
    name                    = string
    management_group_scopes = list(string)
    actions                 = list(string)
    not_actions             = list(string)
    data_actions            = list(string)
    not_data_actions        = list(string)
  }))
  description = "custom roles defined on the management groups"
}

variable "management_groups" {
  type        = map(string)
  description = "map of management group key to group id"
}
