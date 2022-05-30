variable "policies" {
  type = map(object({
    display_name      = string
    description       = string
    mode              = string
    metadata          = map(any)
    policy_rule       = string
    parameters        = map(any)
    predefined_params = list(string)
    }
  ))
}

variable "management_group" {
  type        = string
  description = "management group where definition is stored"
}
