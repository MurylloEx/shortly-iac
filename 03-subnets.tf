# Sub-rede pública: 10.0.0.0 ~ 10.0.31.255 (8.192 Sub-redes)
resource "aws_subnet" "public_us_east_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/19"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-us-east-1a"
  }
}

# Sub-rede privada: 10.0.32.0 - 10.0.63.255 (8.192 Sub-redes)
resource "aws_subnet" "private_us_east_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "private-us-east-1a"
  }
}
