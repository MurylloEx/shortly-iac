resource "tls_private_key" "privkey" {
  algorithm = "RSA" 
  rsa_bits = 4096
}

resource "aws_key_pair" "terraform_aws_us_east_1" {
  key_name   = "terraform_aws"
  public_key = "${tls_private_key.privkey.public_key_openssh}"
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0044130ca185d0880"
  instance_type = "t3.micro"
  key_name      = "terraform_aws"
  subnet_id     = aws_subnet.public_us_east_1a.id

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.security_group_ec2.id]

  # https://prnt.sc/2yRQmPpe4cxk
  # provisioner "local-exec" {

  # }

  tags = {
    Name = "ec2_instance"
  }
}
