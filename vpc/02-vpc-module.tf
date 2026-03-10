# ---------------------------------------------
# VPC Module
# ---------------------------------------------

module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  name = "${local.name}-${var.vpc_name}"
  cidr = var.vpc_cidr_block

  azs             = var.vpc_availability_zones
  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.common_tags
}