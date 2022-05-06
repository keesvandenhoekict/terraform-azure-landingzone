variable "initiative_assignments" {
  type = map(object({
    is_custom        = bool
    initiative_name  = string
    management_group = string
    parameters       = map(any)
    })
  )
}

variable "management_groups" {
  type        = map(string)
  description = "map of management group key to group id"
}
