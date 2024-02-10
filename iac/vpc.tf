resource "aws_vpc" "gh-self-runner-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "gh-self-runner-vpc"
  }
}
