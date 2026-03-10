# ---------------------------------------------
# Bastion EC2 Instance
# ---------------------------------------------

resource "aws_instance" "bastion" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.terraform_key.key_name

  subnet_id = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name}-bastion"
    }
  )
}