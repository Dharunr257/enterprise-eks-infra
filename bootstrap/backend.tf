terraform {
  backend "s3" {
    bucket         = "dharun-enterprise-eks-tfstate"
    key            = "bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dharun-enterprise-eks-locks"
    encrypt        = true
  }
}