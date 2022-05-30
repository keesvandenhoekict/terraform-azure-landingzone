variable "tag_required" {
  type = any
  default = {
    display_name = "Tag is Required"
    description  = "Require the tag to be present"
    mode         = "Indexed"
    metadata = {
      category = "General"
    }
    policy_rule = <<RULE
{
    "if": {
            "field": "[concat('tags[', parameters('tagName'), ']')]",
            "exists": false
          }
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
