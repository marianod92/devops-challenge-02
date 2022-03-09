resource "aws_ec2_tag" "eks_required_tags_for_vpc" {
  for_each    = toset(concat([local.vpc_id], local.public_subnet_ids, local.private_subnet_ids))
  resource_id = each.key
  key         = "kubernetes.io/cluster/${module.eks_cluster.eks_cluster_id}"
  value       = "shared"
}

resource "aws_ec2_tag" "eks_required_tags_for_public_subnets" {
  for_each    = toset(local.public_subnet_ids)
  resource_id = each.key
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "eks_required_tags_for_private_subnets" {
  for_each    = toset(local.private_subnet_ids)
  resource_id = each.key
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}