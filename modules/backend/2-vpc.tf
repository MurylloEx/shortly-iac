# Virtual Private Cloud

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16" # Bloco CIDR da VPC inteira
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.app_stage}-${var.app_name}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"        # Bloco CIDR da sub-rede privada
  availability_zone       = "${var.aws_region}a" # Zona de disponibilidade da rede privada
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_stage}-${var.app_name}-public-subnet"
  }

  depends_on = [aws_vpc.main_vpc]
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"        # Bloco CIDR da sub-rede privada
  availability_zone = "${var.aws_region}a" # Zona de disponibilidade da rede privada

  tags = {
    Name = "${var.app_stage}-${var.app_name}-private-subnet-a"
  }

  depends_on = [aws_vpc.main_vpc]
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.3.0/24"        # Bloco CIDR da sub-rede privada
  availability_zone = "${var.aws_region}b" # Zona de disponibilidade da rede privada

  tags = {
    Name = "${var.app_stage}-${var.app_name}-private-subnet-b"
  }

  depends_on = [aws_vpc.main_vpc]
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.4.0/24"        # Bloco CIDR da sub-rede privada
  availability_zone = "${var.aws_region}d" # Zona de disponibilidade da rede privada

  tags = {
    Name = "${var.app_stage}-${var.app_name}-private-subnet-c"
  }

  depends_on = [aws_vpc.main_vpc]
}
