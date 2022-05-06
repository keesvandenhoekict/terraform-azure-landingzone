data "azurerm_policy_set_definition" "initiative" {
  display_name          = var.is_custom ? null : var.initiative_name
  name                  = var.is_custom ? var.initiative_name : null
  management_group_name = var.is_custom ? reverse(split("/", var.management_groups[var.management_group]))[0] : null
}
