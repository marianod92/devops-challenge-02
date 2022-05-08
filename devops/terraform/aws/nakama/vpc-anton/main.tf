module "label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["cluster"]
  context    = module.this.context
}

module "vpc" {
  source     = "cloudposse/vpc/aws"
  version    = "0.28.1"
  cidr_block = var.cidr_block
  context    = module.this.context
}

module "subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "0.39.8"
  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = var.nat_gateway_enabled
  nat_instance_enabled = var.nat_instance_enabled
  context              = module.this.context
}