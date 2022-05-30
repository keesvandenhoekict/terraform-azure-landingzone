output "policy_parameters" {

  value = {
    regions = merge(local.all_regions, local.all_region_codes)
    types   = merge(local.all_type_prefixes, local.all_types)
  }
}
