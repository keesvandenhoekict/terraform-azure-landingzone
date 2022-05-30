variable "tag_rg_required" {
  type = any
  default = {
    display_name = "Required Resource group Tag"
    description  = "Require resource group to have the tag"
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
            "exists": false
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
        defaultValue  = null
        allowedValues = []
        metadata = {
          displayName = "Tag Name"
          description = "Name of the tag to validate"
        }
      }
      valueList = {
        type          = "Array"
        defaultValue  = null
        allowedValues = []
        metadata = {
          displayName = "Value list"
          description = "Values that the tag is allowed to have"
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
    predefined_params = []
  }
}
