variable "initiatives" {
  type = map(object({
    name         = string
    display_name = string
    policies     = list(string)
  }))
}
