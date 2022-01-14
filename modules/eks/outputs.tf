output "cluster" {
  description = "EKS cluster object"
  value       = aws_eks_cluster.eks
}

output "nodes_group" {
  description = "EKS cluster node group object"
  value       = aws_eks_node_group.nodes_general
}