variable "is_custom" {
  type        = bool
  description = "Whether a custom or build-in initiatve"
}

variable "initiative_name" {
  type        = string
  description = "display name for a build-in initiative or name for custom initiative"
}

variable "management_group" {
  type        = string
  description = "key of the management group that the initiative is created in or null for build-in initiative"
  default     = null
}

variable "management_groups" {
  type        = map(string)
  description = "map of management group key to group id"
  default     = {}
}
