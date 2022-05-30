variable "tag_from_list" {
  type = any
  default = {
    tag_from_list = {
      display_name = "Tag value from list"
      description  = "Restrict the tag value to a list of defined values"
      mode         = "Indexed"
      metadata = {
        category = "General"
      }
      policy_rule = <<RULE
{
    "if": {
       "allOf": [
        {
            "field": "[concat('tags[', parameters('tagName'), ']')]",
            "exists": true
        },
         {
            "field": "[concat('tags[', parameters('tagName'), ']')]",
            "notIn": "[parameters('valueList')]"
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
}
