variable "resource_type" {
  type        = string
  description = "resource_type"
}

variable "application" {
  type        = string
  description = "application or workload"
  default     = null
}

variable "environment" {
  type        = string
  description = "environment"
  default     = null
}

variable "region" {
  type        = string
  description = "Azure region"
}

variable "instance" {
  type        = string
  description = "Instance / number or something to make the resource name unique"
  default     = null
}
