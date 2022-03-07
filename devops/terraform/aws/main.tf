module "label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["cluster"]
  context    = module.this.context
}

locals {
  tags                            = { "kubernetes.io/cluster/${module.label.id}" = "shared" }
  eks_worker_ami_name_filter      = "amazon-eks-node-${var.kubernetes_version}*"
  public_subnets_additional_tags  = { "kubernetes.io/role/elb" : 1 }
  private_subnets_additional_tags = { "kubernetes.io/role/internal-elb" : 1 }
}

module "vpc" {
  source     = "cloudposse/vpc/aws"
  version    = "0.28.1"
  cidr_block = "172.16.0.0/16"
  tags       = local.tags
  context    = module.this.context
}

module "subnets" {
  source                          = "cloudposse/dynamic-subnets/aws"
  version                         = "0.39.8"
  availability_zones              = var.availability_zones
  vpc_id                          = module.vpc.vpc_id
  igw_id                          = module.vpc.igw_id
  cidr_block                      = module.vpc.vpc_cidr_block
  nat_gateway_enabled             = var.nat_gateway_enabled
  nat_instance_enabled            = var.nat_instance_enabled
  tags                            = local.tags
  public_subnets_additional_tags  = local.public_subnets_additional_tags
  private_subnets_additional_tags = local.private_subnets_additional_tags
  context                         = module.this.context
}

module "eks_cluster" {
  source                                                    = "cloudposse/eks-cluster/aws"
  version                                                   = "0.45.0"
  region                                                    = var.region
  vpc_id                                                    = module.vpc.vpc_id
  subnet_ids                                                = concat(module.subnets.private_subnet_ids, module.subnets.public_subnet_ids)
  kubernetes_version                                        = var.kubernetes_version
  local_exec_interpreter                                    = var.local_exec_interpreter
  oidc_provider_enabled                                     = var.oidc_provider_enabled
  enabled_cluster_log_types                                 = var.enabled_cluster_log_types
  cluster_log_retention_period                              = var.cluster_log_retention_period
  cluster_encryption_config_enabled                         = var.cluster_encryption_config_enabled
  cluster_encryption_config_kms_key_id                      = var.cluster_encryption_config_kms_key_id
  cluster_encryption_config_kms_key_enable_key_rotation     = var.cluster_encryption_config_kms_key_enable_key_rotation
  cluster_encryption_config_kms_key_deletion_window_in_days = var.cluster_encryption_config_kms_key_deletion_window_in_days
  cluster_encryption_config_kms_key_policy                  = var.cluster_encryption_config_kms_key_policy
  cluster_encryption_config_resources                       = var.cluster_encryption_config_resources
  addons                                                    = var.addons
  create_security_group                                     = false
  allowed_security_group_ids                                = [module.vpc.vpc_default_security_group_id]
  allowed_cidr_blocks                                       = [module.vpc.vpc_cidr_block]
  context                                                   = module.this.context
}

module "eks_node_group" {
  source            = "cloudposse/eks-node-group/aws"
  version           = "0.27.1"
  subnet_ids        = module.subnets.private_subnet_ids
  cluster_name      = module.eks_cluster.eks_cluster_id
  instance_types    = var.instance_types
  desired_size      = var.desired_size
  min_size          = var.min_size
  max_size          = var.max_size
  kubernetes_labels = var.kubernetes_labels
  module_depends_on = module.eks_cluster.kubernetes_config_map_id
  context           = module.this.context
}