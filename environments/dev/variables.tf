variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "cluster_version" {
  description = "EKS Cluster Version"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public Subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private Subnet CIDRs"
  type        = list(string)
}

variable "instance_types" {
  description = "EKS Worker Node Instance Types"
  type        = list(string)
}

variable "capacity_type" {
  description = "Node Capacity Type"
  type        = string
}

variable "desired_size" {
  description = "Desired Worker Nodes"
  type        = number
}

variable "min_size" {
  description = "Minimum Worker Nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum Worker Nodes"
  type        = number
}