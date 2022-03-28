variable "toplevel_name" {
  type        = string
  description = "name of toplevel management group"
  default     = "Azure landing zone"
}

variable "toplevel_parent" {
  type        = string
  description = "group id of parent of the landing zone toplevel"
  default     = null
}

variable "hub_name" {
  type        = string
  description = "name of hub management group"
  default     = "Hub"
}

variable "workload_name" {
  type        = string
  description = "name of workload management group"
  default     = "Workloads"
}

variable "environments" {
  type        = set(string)
  description = "The environments needed, prod, dev, test etc." 
}
