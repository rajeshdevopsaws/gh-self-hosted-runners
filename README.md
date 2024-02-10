
cd iac

terraform init

terraform apply

chmod 400 gh-self-runner.pem 

ssh -i  gh-self-runner.pem ubuntu@52.88.125.222
