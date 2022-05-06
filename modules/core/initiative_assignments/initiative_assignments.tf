provider "azurerm" {
  features {}
}

module "initiative_lookup" {
  source            = "../../internal/initiative_lookup"
  for_each          = var.initiative_assignments
  initiative_name   = each.value.initiative_name
  is_custom         = each.value.is_custom
  management_group  = each.value.management_group
  management_groups = var.management_groups
}

resource "azurerm_management_group_policy_assignment" "assignment" {
  for_each             = var.initiative_assignments
  name                 = each.key
  policy_definition_id = module.initiative_lookup[each.key].initiative.id
  management_group_id  = var.management_groups[each.value.management_group]
  parameters           = local.assignment_params[each.key]
}

locals {
  assignment_params = { for id, initiative in var.initiative_assignments : id => jsonencode({ for p, v in initiative.parameters : p => { value = v } }) }

  output_assignments_ids = { for k, v in azurerm_management_group_policy_assignment.assignment : k => v.id }
}
