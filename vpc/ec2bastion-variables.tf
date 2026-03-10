# ---------------------------------------------
# Bastion Variables
# ---------------------------------------------

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH Key Name"
  type        = string
  default     = "terraform-key"
}