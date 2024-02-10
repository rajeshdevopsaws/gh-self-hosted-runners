resource "local_file" "aws_key" {
  content  = tls_private_key.gh-self-runner_ssh_key.private_key_pem
  filename = "gh-self-runner.pem"
}

output "gh-self-runner_public_ip" {
  value = aws_instance.gh-self-runner.public_ip
}