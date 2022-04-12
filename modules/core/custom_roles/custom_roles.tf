provider "azurerm" {
  features {}
}

resource "azurerm_role_definition" "custom_role" {
  for_each = var.custom_roles
  name     = each.value.name
  scope    = var.management_groups[each.value.management_group_scopes[0]]
  permissions {
    actions          = each.value.actions
    not_actions      = each.value.not_actions
    data_actions     = each.value.data_actions
    not_data_actions = each.value.not_data_actions
  }
  assignable_scopes = [
    for group in each.value.management_group_scopes : var.management_groups[group]
  ]
}
locals {
  output_role_ids = { for k,v in azurerm_role_definition.custom_role : k => v.role_definition_resource_id }
}