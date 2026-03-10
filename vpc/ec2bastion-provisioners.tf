# ---------------------------------------------
# Bastion Provisioner
# ---------------------------------------------

resource "null_resource" "bastion_provisioner" {

  depends_on = [aws_instance.bastion]

  connection {

    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.terraform_key.private_key_pem
    host        = aws_instance.bastion.public_ip
  }

  provisioner "remote-exec" {

    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx"
    ]
  }
}