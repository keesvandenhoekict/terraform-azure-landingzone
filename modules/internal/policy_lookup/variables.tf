variable "is_custom" {
  type        = bool
  description = "Whether a custom or build-in policy"
}

variable "policy_name" {
  type        = string
  description = "display name for a build-in policy or name for custom policy"
}

variable "management_group" {
  type        = string
  description = "key of the management group that the custom policy is created in or null for build-in policy"
  default     = null
}

variable "management_groups" {
  type        = map(string)
  description = "map of management group key to group id"
  default     = {}
}
