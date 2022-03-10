module "label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["cluster"]
  context    = module.this.context
}

locals {
  vpc_id                        = data.terraform_remote_state.remote_vpc.outputs.vpc_id
  vpc_default_security_group_id = data.terraform_remote_state.remote_vpc.outputs.vpc_default_security_group_id
  vpc_cidr                      = data.terraform_remote_state.remote_vpc.outputs.vpc_cidr
  public_subnet_ids             = data.terraform_remote_state.remote_vpc.outputs.public_subnet_ids
  private_subnet_ids            = data.terraform_remote_state.remote_vpc.outputs.private_subnet_ids
  eks_subnets_ids               = concat(local.private_subnet_ids, local.public_subnet_ids)
  eks_worker_ami_name_filter    = "amazon-eks-node-${var.kubernetes_version}*"
}

data "aws_eks_cluster" "eks" {
  name = module.eks_cluster.eks_cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks_cluster.eks_cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

module "eks_cluster" {
  source                                                    = "cloudposse/eks-cluster/aws"
  version                                                   = "0.45.0"
  region                                                    = var.region
  vpc_id                                                    = local.vpc_id
  subnet_ids                                                = local.eks_subnets_ids
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
  allowed_security_group_ids                                = [local.vpc_default_security_group_id]
  allowed_cidr_blocks                                       = [local.vpc_cidr]
  context                                                   = module.this.context
}

# resource "aws_iam_policy" "policy_eks_node_group_to_ecr" {
#   name        = "policy-eks-node-group-to-ecr"
#   path        = "/"
#   description = "AWSServiceRoleForAmazonEKSNodegroupToECR"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:BatchGetImage",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:GetAuthorizationToken"]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }

module "eks_node_group" {
  source            = "cloudposse/eks-node-group/aws"
  version           = "0.27.1"
  subnet_ids        = local.private_subnet_ids
  cluster_name      = module.eks_cluster.eks_cluster_id
  instance_types    = var.instance_types
  desired_size      = var.desired_size
  min_size          = var.min_size
  max_size          = var.max_size
  kubernetes_labels = var.kubernetes_labels
  module_depends_on = module.eks_cluster.kubernetes_config_map_id
  # node_role_policy_arns = [aws_iam_policy.policy_eks_node_group_to_ecr.arn]
  context = module.this.context
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

resource "kubernetes_namespace" "nakama_namespace" {
  metadata { name = var.name }
  depends_on = [module.eks_node_group]
}

resource "helm_release" "nakama" {
  name      = var.name
  namespace = kubernetes_namespace.nakama_namespace.id
  chart     = "../../../../kubernetes/helm/"
  values    = [file("../../../../kubernetes/helm/values.yaml")]
  set {
    name  = "console.username"
    value = var.nakama_user
  }

  set {
    name  = "console.password"
    value = var.nakama_password
  }
}