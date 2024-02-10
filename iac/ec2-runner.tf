resource "tls_private_key" "gh-self-runner_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  depends_on = [
    tls_private_key.gh-self-runner_ssh_key
  ]
  key_name   = format("gh-self-runner_ssh_key-%s", random_string.random_name.result)
  public_key = tls_private_key.gh-self-runner_ssh_key.public_key_openssh
}

resource "aws_instance" "gh-self-runner" {
  ami                  = "ami-008fe2fc65df48dac"
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.ssh.key_name
  subnet_id            = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.gh-self-runner-SG.id]
  associate_public_ip_address = true
  source_dest_check           = false
  tags = {
    Name = "gh-self-runner-Instance"
  }
}


