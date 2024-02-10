resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.gh-self-runner-vpc.id

  tags = {
    Name = "gh-self-runner Gateway"
  }
}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.gh-self-runner-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "gh-self-runner-Public-Subnet-Route"
  }
}
