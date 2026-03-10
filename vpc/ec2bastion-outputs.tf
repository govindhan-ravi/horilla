# ---------------------------------------------
# Bastion Outputs
# ---------------------------------------------

output "bastion_public_ip" {

  description = "Bastion Public IP"
  value       = aws_instance.bastion.public_ip
}

output "bastion_ssh_command" {

  value = "ssh -i private-key/terraform-key.pem ubuntu@${aws_instance.bastion.public_ip}"
}