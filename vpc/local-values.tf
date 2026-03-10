# ---------------------------------------------
# Local Values
# ---------------------------------------------

locals {

  name = "${var.business_division}-${var.environment}"

  common_tags = {
    BusinessDivision = var.business_division
    Environment      = var.environment
    ManagedBy        = "Terraform"
  }
}