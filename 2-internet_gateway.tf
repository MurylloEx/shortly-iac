resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  depends_on = [aws_vpc.main_vpc]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }

  depends_on = [
    aws_vpc.main_vpc,
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id

  depends_on = [
    aws_subnet.public_subnet,
    aws_route_table.public
  ]
}
