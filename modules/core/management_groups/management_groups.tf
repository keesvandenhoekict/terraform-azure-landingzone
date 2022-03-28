provider "azurerm" {
  features {}
}

module "name_policy_mg_toplevel" {
  source        = "../../internal/name_policy"
  resource_type = "mg"
  application   = var.toplevel_name
  region        = null
  environment   = null
}

resource "azurerm_management_group" "toplevel" {
  display_name               = module.name_policy_mg_toplevel.name
  parent_management_group_id = var.toplevel_parent
}

module "name_policy_mg_hub" {
  source        = "../../internal/name_policy"
  resource_type = "mg"
  application   = var.hub_name
  region        = null
  environment   = null
}

resource "azurerm_management_group" "hub" {
  display_name               = module.name_policy_mg_hub.name
  parent_management_group_id = azurerm_management_group.toplevel.id
}

module "name_policy_mg_workload" {
  source        = "../../internal/name_policy"
  resource_type = "mg"
  application   = var.workload_name
  region        = null
  environment   = null
}

resource "azurerm_management_group" "workload" {
  display_name               = module.name_policy_mg_workload.name
  parent_management_group_id = azurerm_management_group.toplevel.id
}

module "name_policy_mg_workload_env" {
  source        = "../../internal/name_policy"
  for_each      = var.environments
  resource_type = "mg"
  application   = var.workload_name
  region        = null
  environment   = each.key
}

resource "azurerm_management_group" "workload_env" {
  for_each                   = var.environments
  display_name               = module.name_policy_mg_workload_env[each.key].name
  parent_management_group_id = azurerm_management_group.workload.id
}

locals {
  output_management_group_ids = merge(
    { toplevel = azurerm_management_group.toplevel.id
      hub      = azurerm_management_group.hub.id
      workload = azurerm_management_group.workload.id
    },
  { for s in keys(azurerm_management_group.workload_env) : s => azurerm_management_group.workload_env[s].id })
}
