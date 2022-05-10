provider "azurerm" {
  features {}
}

data "azurerm_management_group" "parent" {
  display_name = var.parent_management_group_display_name
}

module "name_policy_mg_workload" {
  source        = "../../internal/name_policy"
  for_each      = var.management_groups
  resource_type = "mg"
  application   = each.value.display_name
  region        = null
  environment   = null
}

resource "azurerm_management_group" "level_0" {
  for_each                   = { for k, v in var.management_groups : k => v if v.level == 0 }
  display_name               = module.name_policy_mg_workload[each.key].name
  parent_management_group_id = data.azurerm_management_group.parent.id
}

resource "azurerm_management_group" "level_1" {
  for_each                   = { for k, v in var.management_groups : k => v if v.level == 1 }
  display_name               = module.name_policy_mg_workload[each.key].name
  parent_management_group_id = azurerm_management_group.level_0[each.value.parent].id
}

resource "azurerm_management_group" "level_2" {
  for_each                   = { for k, v in var.management_groups : k => v if v.level == 2 }
  display_name               = module.name_policy_mg_workload[each.key].name
  parent_management_group_id = azurerm_management_group.level_1[each.value.parent].id
}

resource "azurerm_management_group" "level_3" {
  for_each                   = { for k, v in var.management_groups : k => v if v.level == 3 }
  display_name               = module.name_policy_mg_workload[each.key].name
  parent_management_group_id = azurerm_management_group.level_2[each.value.parent].id
}

locals {
  output_management_group_ids = merge(
    { for k, v in azurerm_management_group.level_0 : k => v.id },
    { for k, v in azurerm_management_group.level_1 : k => v.id },
    { for k, v in azurerm_management_group.level_2 : k => v.id },
    { for k, v in azurerm_management_group.level_3 : k => v.id }
  )
}
