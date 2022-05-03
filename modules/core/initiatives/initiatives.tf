provider "azurerm" {
  features {}
}

resource "azurerm_policy_set_definition" "initiative" {
  for_each = var.initiatives

  name         = each.value.name
  policy_type  = "Custom"
  display_name = each.value.display_name
  parameters   = <<PARAMETERS
  {
          ${join(",\n", [for k, v in local.all_params_to_json : v if contains(local.initiative_to_param_names[each.value.name], k)])}
  }
  PARAMETERS
  dynamic "policy_definition_reference" {
    for_each = each.value.policies
    content {
      policy_definition_id = data.azurerm_policy_definition.defs[policy_definition_reference.value].id
      parameter_values     = length(local.policy_to_param_names[policy_definition_reference.value]) == 0 ? null : <<VALUE
      {
        ${join(",\n", [for k, v in local.all_params_to_json_value : v if contains(local.policy_to_param_names[policy_definition_reference.value], k)])}
      }
      VALUE
    }
  }
}

data "azurerm_policy_definition" "defs" {
  for_each     = toset(flatten([for initiative in var.initiatives : initiative.policies]))
  display_name = each.value
}

locals {

  policy_to_param_names     = { for k, v in data.azurerm_policy_definition.defs : k => keys(jsondecode(v.parameters)) }
  initiative_to_param_names = { for init in var.initiatives : init.name => flatten([for policy, params in local.policy_to_param_names : params if contains(init.policies, policy)]) }
  all_params                = merge(flatten([for defs in values(data.azurerm_policy_definition.defs) : jsondecode(defs.parameters)])...)
  all_params_to_json        = { for k, v in local.all_params : k => trimsuffix(trimprefix(jsonencode(zipmap([k], [v])), "{"), "}") }
  all_params_to_json_value  = { for k, v in local.all_params : k => "\"${k}\": {\"value\": \"[parameters('${k}')]\"}" }

  output_initiative_ids = { for k, v in azurerm_policy_set_definition.initiative : k => v.id }
}
