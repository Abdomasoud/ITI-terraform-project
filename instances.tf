resource "aws_instance" "bastion" {
  depends_on                  = [aws_security_group.allow_ssh]
  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet-1.id
  security_groups             = [aws_security_group.allow_ssh.id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  tags = {
    "Name" = "Bastion Host"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.bastion.public_ip} > bastion_ip.txt"
  }

}
resource "aws_instance" "server" {
  depends_on                  = [aws_security_group.allow_ssh_port]
  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet-1.id
  security_groups             = [aws_security_group.allow_ssh_port.id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = false


  tags = {
    "Name" = "Web Server"
  }

}