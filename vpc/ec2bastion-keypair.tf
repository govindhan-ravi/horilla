# ---------------------------------------------
# Generate Private Key
# ---------------------------------------------

resource "tls_private_key" "terraform_key" {

  algorithm = "RSA"
  rsa_bits  = 4096
}

# ---------------------------------------------
# Create AWS Key Pair
# ---------------------------------------------

resource "aws_key_pair" "terraform_key" {

  key_name   = "${local.name}-${var.key_name}"
  public_key = tls_private_key.terraform_key.public_key_openssh
}

# ---------------------------------------------
# Save Private Key Locally
# ---------------------------------------------

resource "local_file" "private_key" {

  content  = tls_private_key.terraform_key.private_key_pem
  filename        = "${path.module}/private-key/terraform-key.pem"
  file_permission = "0400"
}