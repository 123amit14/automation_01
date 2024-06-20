resource "aws_instance" "instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids  # Use vpc_security_group_ids instead
  associate_public_ip_address = var.associate_public_ip_address

  tags = var.tags

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y apache2",
      "sudo apt install -y mysql-client",
      "sudo apt install -y php libapache2-mod-php php-mysql",
      "sudo systemctl restart apache2",
      // Additional commands can be added as needed
    ]
  }
}
