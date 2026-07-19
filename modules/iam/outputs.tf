output "cluster_role_arn" {

  value = aws_iam_role.eks_cluster_role.arn

}

output "node_role_arn" {

  value = aws_iam_role.eks_node_role.arn

}

output "ebs_csi_role_arn" {
  value = aws_iam_role.ebs_csi_role.arn
}