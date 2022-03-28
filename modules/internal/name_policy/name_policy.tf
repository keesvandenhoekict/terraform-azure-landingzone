#
# Advise to use the abbreviations according to https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
#

locals {
  separator = "-"

  // non null versions of parameters
  application_n = var.application == null ? "" : var.application
  environment_n = var.environment == null ? "" : var.environment
  region_n      = var.region == null ? "" : var.region
  instance_n    = var.instance == null ? "" : var.instance

  // parameters with separator prefixed, if not empty 
  application_p = local.application_n == "" ? "" : "${local.separator}${var.application}"
  environment_p = local.environment_n == "" ? "" : "${local.separator}${var.environment}"
  region_p      = local.region_n == "" ? "" : "${local.separator}${var.region}"
  instance_p    = local.instance_n == "" ? "" : "${local.separator}${var.instance}"

  name_w_separator  = format("%s%s%s%s%s", var.resource_type, local.application_p, local.environment_p, local.region_p, local.instance_p)
  name_wo_separator = format("%s%s%s%s%s", var.resource_type, local.application_n, local.environment_n, local.region_n, local.instance_n)
  app_mapping = {
    # azure automation. max 50 characters
    aa = substr(local.name_w_separator, 0, 50)

    # container registry
    cr = local.name_wo_separator

    # keyvault at most 24 characters
    kv = substr(local.name_wo_separator, 0, 24)

    # storage account , lowercase letters and numbers only at most 24 characters
    st = substr(lower(local.name_wo_separator), 0, 24)
  }
  # define the output
  output_name = lookup(local.app_mapping, var.resource_type, local.name_w_separator)
}
