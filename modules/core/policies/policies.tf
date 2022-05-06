provider "azurerm" {
  features {}
}

resource "azurerm_policy_definition" "policy" {
  for_each = var.policies

  name                = each.key
  policy_type         = "Custom"
  mode                = each.value.mode
  display_name        = each.value.display_name
  metadata            = jsonencode(each.value.metadata)
  policy_rule         = each.value.policy_rule
  management_group_id = each.value.management_group == null ? null : var.management_groups[each.value.management_group]
  parameters          = jsonencode(each.value.parameters)
}

locals {
  output_policy_ids = { for k, v in azurerm_policy_definition.policy : k => v.id }
}
