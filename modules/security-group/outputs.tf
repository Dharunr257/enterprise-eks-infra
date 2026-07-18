output "cluster_security_group_id" {

  description = "EKS Cluster Security Group"

  value = aws_security_group.eks_cluster.id

}

output "node_security_group_id" {

  description = "EKS Node Security Group"

  value = aws_security_group.eks_nodes.id

}