# ---------------------------------------------
# Bastion Security Group
# ---------------------------------------------

resource "aws_security_group" "bastion_sg" {

  name        = "${local.name}-bastion-sg"
  description = "Allow SSH Access"
  vpc_id      = module.vpc.vpc_id

  ingress {

    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}