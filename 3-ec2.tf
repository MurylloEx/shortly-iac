# Instancias EC2

resource "aws_security_group" "ec2_security_group" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    description = "Allow connections from public AWS API Gateway"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = data.aws_ip_ranges.api_gateway.cidr_blocks
  }

  ingress {
    description = "Allow ICMP packets from public Internet"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH connections from public Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outgoing connections to public Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [
    aws_vpc.main_vpc,
    data.aws_ip_ranges.api_gateway
  ]
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro" # atualize com o tipo de instância desejado
  key_name      = var.ssh_key_name # atualize com o nome da chave SSH existente

  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.ec2_security_group.id]

  user_data = templatefile("${path.module}/scripts/bootstrap.sh", {
    GITHUB_PERSONAL_TOKEN       = var.github_personal_token,
    GITHUB_REPOSITORY_NAME      = var.github_repository_name,
    GITHUB_REPOSITORY_USER_NAME = var.github_repository_name,
    GITHUB_CLONE_PATH           = var.github_clone_path,
    GITHUB_FINAL_CLONE_NAME     = var.github_final_clone_name
  })

  tags = {
    Name = "ec2-instance"
  }

  depends_on = [
    data.aws_ami.ubuntu,
    aws_subnet.public_subnet,
    aws_security_group.ec2_security_group
  ]
}
