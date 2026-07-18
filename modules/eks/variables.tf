variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "cluster_role_arn" {
  description = "EKS Cluster IAM Role ARN"
  type        = string
}

variable "node_role_arn" {
  description = "EKS Worker Node IAM Role ARN"
  type        = string
}

variable "cluster_subnet_ids" {
  description = "Subnets used by EKS Control Plane"
  type        = list(string)
}

variable "node_subnet_ids" {
  description = "Private subnets for worker nodes"
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "Cluster Security Group"
  type        = string
}

variable "instance_types" {
  description = "Worker node instance types"
  type        = list(string)

  default = [
    "t3.medium"
  ]
}

variable "desired_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "cluster_version" {
  type    = string
  default = "1.33"
}

variable "capacity_type" {
  description = "Node Group Capacity Type"
  type        = string
  default     = "ON_DEMAND"
}