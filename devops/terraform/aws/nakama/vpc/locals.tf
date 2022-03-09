locals {
  az_map       = module.utils.region_az_alt_code_maps["to_short"]
  short_region = local.az_map["${var.region}"]
}

module "utils" {
  source  = "cloudposse/utils/aws"
  version = "v0.8.1"
}