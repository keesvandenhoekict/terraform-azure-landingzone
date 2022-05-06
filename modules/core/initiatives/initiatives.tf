provider "azurerm" {
  features {}
}

resource "azurerm_policy_set_definition" "initiative" {
  for_each = var.initiatives

  name                = each.value.name
  policy_type         = "Custom"
  display_name        = each.value.display_name
  management_group_id = lookup(var.management_groups, each.value.management_group, null)
  parameters          = <<PARAMETERS
  {
          ${join(",\n", [for k, v in local.all_params_to_json : v if contains(local.initiative_to_param_names[each.value.name], k)])}
  }
  PARAMETERS
  dynamic "policy_definition_reference" {
    for_each = each.value.policies
    content {
      policy_definition_id = module.policy_lookup[policy_definition_reference.key].definition.id
      parameter_values     = length(local.policy_to_param_names[policy_definition_reference.key]) == 0 ? null : <<VALUE
      {
        ${join(",\n", [for k, v in local.all_params_to_json_value : v if contains(local.policy_to_param_names[policy_definition_reference.key], k)])}
      }
      VALUE
    }
  }
}

module "policy_lookup" {
  source            = "../../internal/policy_lookup"
  for_each          = merge(values(var.initiatives).*.policies...)
  policy_name       = each.value.name
  is_custom         = each.value.is_custom
  management_group  = each.value.management_group
  management_groups = var.management_groups
}

locals {
  policy_to_param_names     = { for k, v in module.policy_lookup : k => keys(jsondecode(v.definition.parameters)) }
  initiative_to_param_names = { for init in var.initiatives : init.name => flatten([for policy, params in local.policy_to_param_names : params if contains(keys(init.policies), policy)]) }
  all_params                = merge(flatten([for defs in values(module.policy_lookup) : jsondecode(defs.definition.parameters)])...)
  all_params_to_json        = { for k, v in local.all_params : k => trimsuffix(trimprefix(jsonencode(zipmap([k], [v])), "{"), "}") }
  all_params_to_json_value  = { for k, v in local.all_params : k => "\"${k}\": {\"value\": \"[parameters('${k}')]\"}" }

  output_initiative_ids = { for k, v in azurerm_policy_set_definition.initiative : k => v.id }
}
