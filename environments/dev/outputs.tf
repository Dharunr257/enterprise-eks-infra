##############################################
# VPC Outputs
##############################################

output "vpc_id" {
  description = "VPC ID"

  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"

  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"

  value = module.vpc.private_subnet_ids
}

##############################################
# IAM Outputs
##############################################

output "cluster_role_arn" {
  description = "EKS Cluster IAM Role ARN"

  value = module.iam.cluster_role_arn
}

output "node_role_arn" {
  description = "EKS Worker Node IAM Role ARN"

  value = module.iam.node_role_arn
}

##############################################
# Security Group Outputs
##############################################

output "cluster_security_group_id" {
  description = "Cluster Security Group"

  value = module.security_group.cluster_security_group_id
}

output "node_security_group_id" {
  description = "Node Security Group"

  value = module.security_group.node_security_group_id
}

##############################################
# EKS Outputs
##############################################

output "cluster_name" {
  description = "Amazon EKS Cluster Name"

  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Amazon EKS Endpoint"

  value = module.eks.cluster_endpoint
}

output "cluster_arn" {
  description = "Amazon EKS Cluster ARN"

  value = module.eks.cluster_arn
}

output "cluster_oidc_issuer" {
  description = "OIDC Provider URL"

  value = module.eks.cluster_oidc_issuer
}