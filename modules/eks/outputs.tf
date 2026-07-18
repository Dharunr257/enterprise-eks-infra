output "cluster_name" {

  description = "EKS Cluster Name"

  value = aws_eks_cluster.this.name

}

output "cluster_arn" {

  description = "Cluster ARN"

  value = aws_eks_cluster.this.arn

}

output "cluster_endpoint" {

  description = "API Server Endpoint"

  value = aws_eks_cluster.this.endpoint

}

output "cluster_certificate" {

  description = "Cluster Certificate"

  value = aws_eks_cluster.this.certificate_authority[0].data

}

output "cluster_oidc_issuer" {

  description = "OIDC Issuer URL"

  value = aws_eks_cluster.this.identity[0].oidc[0].issuer

}