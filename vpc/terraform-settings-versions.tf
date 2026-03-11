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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
  }
}

# AWS Provider
provider "aws" {
  region = var.aws_region
}

# Kubernetes Provider
# Authenticate using the cluster information from the EKS module
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This ensures that we always get a fresh token from AWS
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}