module "regions" {
  source = "../regions"
}

module "resource_types" {
  source = "../resource_types"
}

locals {

  all_regions = {
    allRegions = {
      type         = "Array"
      defaultValue = values(module.regions.abbrev_to_region)
      metadata = {
        description = "list of all Azure regions"
        displayname = "All azure regions (do not change default value)"
        strongtype  = "location"
      }
    }
  }
  all_region_codes = {
    allRegionAbbrevs = {
      type         = "Array"
      defaultValue = keys(module.regions.abbrev_to_region)
      metadata = {
        description = "list of all Azure region abbreviation"
        displayname = "All azure region abbreviation (do not change default value)"
      }
    }
  }
  all_type_prefixes = {
    allTypePrefixes = {
      type         = "Array"
      defaultValue = values(module.resource_types.type_to_abbrevs)
      metadata = {
        description = "list of all Azure type abbreviation"
        displayname = "All azure type prefixes (do not change default value)"
      }
    }
  }
  all_types = {
    allTypes = {
      type         = "Array"
      defaultValue = keys(module.resource_types.type_to_abbrevs)
      metadata = {
        description = "list of all Azure type abbreviation"
        displayname = "All azure type prefixes (do not change default value)"
        strongtype  = "type"
      }
    }
  }
}
