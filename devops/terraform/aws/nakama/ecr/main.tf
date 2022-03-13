locals {
  principals_readonly_access_arns = [data.terraform_remote_state.remote_eks.outputs.eks_node_group_role_arn]
}

module "ecr" {
  source                     = "cloudposse/ecr/aws"
  version                    = "v0.32.3"
  name                       = "ecr"
  encryption_configuration   = var.encryption_configuration
  image_names                = ["nakama"]
  context                    = module.this.context
  principals_readonly_access = length(local.principals_readonly_access_arns) > 0 ? local.principals_readonly_access_arns : []
}