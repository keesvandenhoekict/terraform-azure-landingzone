provider "azuread" {}
provider "azurerm" {
  features {}
}

data "azuread_client_config" "current" {}

resource "azuread_group" "new_group" {
  count            = var.ad_group.existing_groupid == null ? 1 : 0
  display_name     = var.ad_group.name
  owners           = concat(tolist(var.ad_group.owners), [data.azuread_client_config.current.object_id])
  security_enabled = true
}

locals {
  // make a list of tupels role - scope
  standard_role_list = flatten([for role in var.ad_group.standard_roles : [
    for scope in var.ad_group.scope : {
      role  = role
      scope = scope
    }
    ]
  ])
  standard_role_map = { for role in local.standard_role_list : "${role.role}-${role.scope}" => role }

  // make a list of tupels role - scope
  custom_role_list = flatten([for role in var.ad_group.custom_roles : [
    for scope in var.ad_group.scope : {
      role  = role
      scope = scope
    }
    ]
  ])
  custom_role_map = { for role in local.custom_role_list : "${role.role}-${role.scope}" => role }


  group_id = var.ad_group.existing_groupid == null ? azuread_group.new_group[0].id : var.ad_group.existing_groupid
}

resource "azurerm_role_assignment" "standard_roles" {
  for_each             = local.standard_role_map
  scope                = var.scopes[each.value.scope]
  role_definition_name = each.value.role
  principal_id         = local.group_id
}

resource "azurerm_role_assignment" "custom_roles" {
  for_each           = local.custom_role_map
  scope              = var.scopes[each.value.scope]
  role_definition_id = var.custom_roles[each.value.role]
  principal_id       = local.group_id
}

resource "azuread_directory_role" "ad_role" {
  for_each     = var.ad_group.ad_roles
  display_name = each.value
}

resource "azuread_directory_role_member" "ad_group_role" {
  for_each         = var.ad_group.ad_roles
  role_object_id   = azuread_directory_role.ad_role[each.value].object_id
  member_object_id = local.group_id
}

output "role_list" {
  value = local.standard_role_list
}

output "role_map" {
  value = local.standard_role_map
}

output "group_id" {
  value = local.group_id
}