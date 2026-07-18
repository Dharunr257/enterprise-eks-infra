terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.5"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Enterprise GitOps Platform"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "Dharun"
    }
  }
}