# ---------------------------------------------
# Terraform Settings and Provider Configuration
# ---------------------------------------------

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31"
    }
  }
}

# AWS Provider
provider "aws" {
  region = var.aws_region
}