variable "tag_rg_region" {
  type = any
  default = {
    display_name = "Region Tag on Resource Group"
    description  = "Have the region abbreviation in a resource group tag"
    mode         = "All"
    metadata = {
      category = "General"
    }
    policy_rule = <<RULE
{
    "if": {
       "allOf": [
            {
            "field": "type",
            "equals": "Microsoft.Resources/subscriptions/resourceGroups"
          },
        {
            "field": "[concat('tags[', parameters('tagName'), ']')]",
            "exists": true
        },
        {
            "value" : "[indexOf(parameters('allRegionAbbrevs'), field(concat('tags[', parameters('tagName'),']')))]",
            "notEquals": "[indexOf(parameters('allRegions'), field('location') )]"
        }
        ]},
    "then": {
      "effect": "[parameters('effect')]"
    }
  }
RULE
    parameters = {

      tagName = {
        type          = "string"
        defaultValue  = "region"
        allowedValues = []
        metadata = {
          displayName = "Tag Name"
          description = "Name of the tag containing the region"
        }
      }
      effect = {
        type          = "string"
        defaultValue  = "Deny"
        allowedValues = ["Audit", "Deny", "Disabled"]
        metadata = {
          displayName = "Effect"
          description = "The effect determines what happens when the policy rule is evaluated to match"
        }
      }
    }
    predefined_params = ["regions"]
  }
}
