variable "ad_group" {
  type = object({
    existing_groupid = string
    name             = string
    owners           = set(string)
    scope            = list(string)
    custom_roles     = set(string)
    standard_roles   = set(string)
    ad_roles         = set(string)
  })
  description = "Azure AD security group with roles assigned"
}

variable "scopes" {
  type        = map(string)
  description = "map of scopes to scope id"
}

variable "custom_roles" {
  type        = map(string)
  description = "map of custom roles to role definition id"
  default     = []
}
