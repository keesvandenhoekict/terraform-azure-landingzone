variable "custom_roles" {
  type = object({
    name                    = string
    management_group_scopes = list(string)
    actions                 = list(string)
    not_actions             = list(string)
    data_actions            = list(string)
    not_data_actions        = list(string)
  })
  description = "custom role defined on the management group(s)"
}

variable "management_groups" {
  type        = map(string)
  description = "map of management group key to group id"
}
