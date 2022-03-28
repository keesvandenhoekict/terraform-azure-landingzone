provider "azurerm" {
  features {}
}

resource "azurerm_consumption_budget_management_group" "hub_budget" {
  for_each            = var.management_group_budget_alerts
  name                = "initial-budget-${each.key}"
  management_group_id = var.management_groups[each.key]
  amount              = each.value.buget_amount_monthly
  time_grain          = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00Z", timestamp())
    // 8766 hours in a year
    end_date = timeadd(formatdate("YYYY-MM-01'T'00:00:00Z", timestamp()), "${2 * 8766}h")
  }

  dynamic "notification" {
    for_each = each.value.actual_notification_percentages
    content {
      enabled        = true
      threshold      = notification.value
      operator       = "GreaterThan"
      threshold_type = "Actual"
      contact_emails = each.value.owner_emails
    }

  }
  dynamic "notification" {
    for_each = each.value.forecast_notification_percentages
    content {
      enabled        = true
      threshold      = notification.value
      operator       = "GreaterThan"
      threshold_type = "Forecasted"
      contact_emails = each.value.owner_emails
    }
  }
  lifecycle {
    ignore_changes = [time_period, notification]
  }
}
