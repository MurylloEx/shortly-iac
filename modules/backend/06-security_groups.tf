# Grupos de segurança do EC2

resource "aws_security_group" "ec2_security_group" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "${var.app_stage}-${var.app_name}-ec2-sg"

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

# Grupos de segurança do MySQL

resource "aws_security_group" "mysql_security_group" {
  name   = "${var.app_stage}-${var.app_name}-mysql-sg"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    description     = "Allow all packets from public subnet with CIDR 10.0.1.0/24"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [aws_subnet.public_subnet.cidr_block] # Bloco de IPs da subnet pública
    security_groups = [aws_security_group.ec2_security_group.id]
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
    aws_subnet.public_subnet,
    aws_security_group.ec2_security_group
  ]
}
