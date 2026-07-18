resource "aws_eks_node_group" "this" {

  cluster_name = aws_eks_cluster.this.name

  node_group_name = "${var.project_name}-${var.environment}-node-group"

  node_role_arn = var.node_role_arn

  subnet_ids = var.node_subnet_ids

  instance_types = var.instance_types

  capacity_type = var.capacity_type

  scaling_config {

    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size

  }

  update_config {

    max_unavailable = 1

  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-node-group"
    }
  )

  depends_on = [

    aws_eks_cluster.this

  ]

}