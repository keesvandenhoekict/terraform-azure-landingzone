variable "tag_region" {
  type = any
  default = {
    region_tag = {
      display_name = "Region Tag"
      description  = "Have the region abbreviation in a resource tag"
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
}
