provider "azurerm" {
  features {}
}

resource "azurerm_role_definition" "custom_role" {
  name  = var.custom_role.name
  scope = var.management_group[var.var.custom_role.management_group_scopes[0]]
  assignable_scopes = [
    for group in var.custom_role.management_group_scopes : var.management_groups[group]
  ]
  permissions {
    actions          = var.custom_role.actions
    not_actions      = var.custom_role.not_actions
    data_actions     = var.custom_role.data_actions
    not_data_actions = var.custom_role.not_data_actions
  }
}
