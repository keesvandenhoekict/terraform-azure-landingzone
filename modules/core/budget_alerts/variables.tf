variable "management_group_budget_alerts" {
  type = map(object({
    owner_emails                      = list(string)
    buget_amount_monthly              = number
    actual_notification_percentages   = list(number)
    forecast_notification_percentages = list(number)
  }))
  description = "budget_alerts map with the name of the management group as key"
}

variable "management_groups" {
  type        = map(string)
  description = "map of management group key to group id"
}
