resource "aws_security_group" "gh-self-runner-SG" {

  description = "ALL"
  vpc_id      = aws_vpc.gh-self-runner-vpc.id
  name        = "gh-self-runner-${random_string.random_name.result}-sg"
  ingress {
    description = "port 22 to setup gh-self-runner"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "port 80 to communicate gh-self-runner"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "port 443 to communicate gh-self-runner"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description = "Allowing all traffic outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
