locals {
  output_policies = {
    taq_region            = var.tag_region
    tag_rg_region         = var.tag_rg_region
    tag_from_list         = var.tag_from_list
    tag_rg_from_list      = var.tag_rg_from_list
    deny_preview_features = var.deny_preview_features
  }
  output_non_compliance_messages = var.non_compliance_messages
}
