output "eks_cluster_id" {
  description = "The name of the cluster"
  value       = module.eks_cluster.eks_cluster_id
}

output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks_cluster.eks_cluster_arn
}

output "eks_node_group_role_arn" {
  description = "ARN of the worker nodes IAM role"
  value       = module.eks_node_group.eks_node_group_role_arn
}