provider "azurerm" {
  features {}
}

module "predefined_parameters" {
  source = "../../internal/policy_predefined_list"
}

resource "azurerm_policy_definition" "policy" {
  for_each = var.policies

  name                = each.key
  policy_type         = "Custom"
  mode                = each.value.mode
  display_name        = each.value.display_name
  metadata            = jsonencode(each.value.metadata)
  policy_rule         = each.value.policy_rule
  management_group_id = var.management_group
  parameters          = jsonencode(merge(each.value.parameters, [for predef in each.value.predefined_params : module.predefined_parameters.policy_parameters[predef]]...))
}

locals {
  output_policy_ids = { for k, v in azurerm_policy_definition.policy : k => v.id }
}
