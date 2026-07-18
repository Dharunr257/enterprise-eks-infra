locals {

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

}

#########################################
# EKS Cluster Security Group
#########################################

resource "aws_security_group" "eks_cluster" {

  name        = "${var.project_name}-${var.environment}-eks-cluster-sg"
  description = "Security Group for Amazon EKS Control Plane"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-cluster-sg"
    }
  )

}

#########################################
# Worker Node Security Group
#########################################

resource "aws_security_group" "eks_nodes" {

  name        = "${var.project_name}-${var.environment}-eks-node-sg"
  description = "Security Group for EKS Worker Nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-node-sg"
    }
  )

}

##################################################
# Cluster -> Node
##################################################

resource "aws_security_group_rule" "cluster_to_nodes" {

  type                     = "egress"

  from_port = 0
  to_port   = 0

  protocol = "-1"

  security_group_id = aws_security_group.eks_cluster.id

  source_security_group_id = aws_security_group.eks_nodes.id

}

##################################################
# Node -> Cluster
##################################################

resource "aws_security_group_rule" "nodes_to_cluster" {

  type = "ingress"

  from_port = 443
  to_port   = 443

  protocol = "tcp"

  security_group_id = aws_security_group.eks_cluster.id

  source_security_group_id = aws_security_group.eks_nodes.id

}

##################################################
# Node Communication
##################################################

resource "aws_security_group_rule" "node_to_node" {

  type = "ingress"

  from_port = 0
  to_port   = 65535

  protocol = "-1"

  security_group_id = aws_security_group.eks_nodes.id

  self = true

}

##################################################
# Node Outbound
##################################################

resource "aws_security_group_rule" "node_egress" {

  type = "egress"

  from_port = 0
  to_port   = 0

  protocol = "-1"

  security_group_id = aws_security_group.eks_nodes.id

  cidr_blocks = [
    "0.0.0.0/0"
  ]

}