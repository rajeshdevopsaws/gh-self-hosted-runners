resource "aws_subnet" "public-subnet" {
  cidr_block        = var.public_subnet_cidr
  vpc_id            = aws_vpc.gh-self-runner-vpc.id
  availability_zone = "us-west-2a"

  tags = {
    Name = " gh-self-runner-Public-Subnet"
  }
}

resource "aws_route_table_association" "public-subnet" {
  route_table_id = aws_route_table.public-route.id
  subnet_id      = aws_subnet.public-subnet.id
}
