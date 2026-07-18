locals {

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

}

resource "aws_eks_cluster" "this" {

  name = "${var.project_name}-${var.environment}"

  version = var.cluster_version

  role_arn = var.cluster_role_arn

  vpc_config {

    subnet_ids = var.cluster_subnet_ids

    security_group_ids = [
      var.cluster_security_group_id
    ]

    endpoint_private_access = false
    endpoint_public_access  = true

  }

  access_config {

    authentication_mode = "API_AND_CONFIG_MAP"

    bootstrap_cluster_creator_admin_permissions = true

  }

  lifecycle {

    prevent_destroy = false

  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-eks"
    }
  )

}