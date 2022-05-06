data "azurerm_policy_definition" "definition" {
  display_name          = var.is_custom ? null : var.policy_name
  name                  = var.is_custom ? var.policy_name : null
  management_group_name = var.is_custom ? reverse(split("/", var.management_groups[var.management_group]))[0] : null
}
