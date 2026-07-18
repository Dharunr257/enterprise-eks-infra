variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "Terraform Backend S3 Bucket"
  type        = string
  default     = "dharun-enterprise-eks-tfstate"
}

variable "dynamodb_table" {
  description = "Terraform Lock Table"
  type        = string
  default     = "dharun-enterprise-eks-locks"
}