##############################################
# VPC Module
##############################################

module "vpc" {

  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment

  cluster_name = "${var.project_name}-${var.environment}"

  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

}

##############################################
# IAM Module
##############################################

module "iam" {

  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment

}

##############################################
# Security Group Module
##############################################

module "security_group" {

  source = "../../modules/security-group"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.vpc.vpc_id

}

##############################################
# Amazon EKS Module
##############################################

module "eks" {

  source = "../../modules/eks"

  project_name = var.project_name
  environment  = var.environment

  cluster_version = var.cluster_version

  ##################################
  # IAM
  ##################################

  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn

  # EKS Pod Identity Role for EBS CSI Driver
  ebs_csi_role_arn = module.iam.ebs_csi_role_arn

  ##################################
  # Networking
  ##################################

  cluster_security_group_id = module.security_group.cluster_security_group_id

  # Control plane can use all subnets
  cluster_subnet_ids = concat(
    module.vpc.public_subnet_ids,
    module.vpc.private_subnet_ids
  )

  # Worker nodes use PUBLIC subnets for this portfolio implementation
  # to avoid NAT Gateway costs while staying within AWS Free Tier.
  node_subnet_ids = module.vpc.public_subnet_ids

  ##################################
  # Node Group
  ##################################

  instance_types = var.instance_types

  capacity_type = var.capacity_type

  desired_size = var.desired_size
  min_size     = var.min_size
  max_size     = var.max_size

  depends_on = [
    module.vpc,
    module.iam,
    module.security_group
  ]

}