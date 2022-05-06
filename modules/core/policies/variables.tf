variable "policies" {
  type = map(object({
    display_name     = string
    description      = string
    mode             = string
    metadata         = map(any)
    policy_rule      = string
    management_group = string
    parameters = map(object({
      type     = string
      metadata = map(string)
    }))
    }
  ))
}

variable "management_groups" {
  type        = map(string)
  description = "map of management group key to group id"
}
