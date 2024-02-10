
# GitHub Self-Hosted Runner

This repository contains the infrastructure as code (IaC) to create a self-hosted runner for GitHub Actions. The runner is created in an EC2 instance and is managed by Terraform.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://aws.amazon.com/cli/)
- [GitHub Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)

### Project Structure
```bash
├── .github
│   └── workflows
│       └── self-runner.yml
├── iac
│   ├── ec2-runner.tf
│   ├── outputs.tf
│   ├── variables.tf
│   ├── security-group.tf
│   └── otherfiles.tf 
└── .gitignore
└── app.py
└── README.md
└── requirements.txt
```


## Usage

1. Clone the repository

```bash
git clone https://github.com/rajeshdevopsaws/gh-self-hosted-runners
```

2. Change to the repository directory

```bash
cd gh-self-hosted-runners
```

3. Change to the `iac` directory

```bash
cd iac
```

4. Initialize Terraform

```bash
terraform init
```

5. Apply the Terraform configuration

```bash
terraform apply -auto-approve
```

> You will have the private key `gh-self-runner.pem` in the `iac` directory. Use this key to SSH into the EC2 instance. The public IP address of the EC2 instance is displayed in the output of the `terraform apply` command.

Outputs:

gh-self-runner_public_ip = "52.88.125.222"

In security-group.tf, I have allowed SSH access and also I opened port 80 and port 443 for the github runner to communicate with the GitHub Actions.


6. SSH into the EC2 instance

```bash
chmod 400 gh-self-runner.pem
```
```bash
ssh -i gh-self-runner.pem ubuntu@<public-ip-address>
```
> Example `ssh -i gh-self-runner.pem ubuntu@52.88.125.222`


### Set up the self-hosted runner

- Go to the newly created repository and navigate to `Settings` > `Actions` > `runners` and then click on `New Self-hosted runner`.

- Select the operating system of the runner and then click on `Add runner`. In this case, the operating system is `Linux` and architecture is `x64`.

- Under the `Configure` instructions, copy the token and run the following command in the EC2 instance.

#### Download the runner package

```bash
mkdir actions-runner && cd actions-runner
```

```bash
curl -o actions-runner-linux-x64-2.312.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.312.0/actions-runner-linux-x64-2.312.0.tar.gz
```

```bash
echo "85c1bbd104d539f666a89edef70a18db2596df374a1b51670f2af1578ecbe031  actions-runner-linux-x64-2.312.0.tar.gz" | shasum -a 256 -c
```
> If you would like to validate the checksum, you can run the above command and verify it.

```bash
tar xzf ./actions-runner-linux-x64-2.312.0.tar.gz
```

#### Configure the runner

```bash
./config.sh --url  https://github.com/<githubusername>/<repositoryname> --token <token>
```

> Replace `<githubusername>` with your GitHub username and `<repositoryname>` with the repository name. Replace `<token>` with the token copied from the GitHub repository while adding the runner.


Example:

```bash
./config.sh --url https://github.com/rajeshdevopsaws/gh-self-hosted-runners --token DWDEW2PLU4K2WWZVTMG53F4KVC
```

> You will be prompted to enter the name of the runner. You can use the default name or provide a custom name.

> You will be prompted to enter the labels for the runner. You can use the default label or provide a custom label.
In this case, I am using the default label `chadz`.

> You will be prompted to enter the work directory for the runner. You can use the default work directory or provide a custom work directory.


#### Start the runner

```bash
./run.sh
```

- Go back to the GitHub repository and you will see the runner is online.

- You can now use the self-hosted runner in your GitHub Actions workflow.

Now commit the changes to the repository and the runner will be triggered.

If you check the my first workflow in the repository, you will see the runner is being used.

```yaml
name: Python CI

on: [push, pull_request]

jobs:
  build:
    name: Build and Run
    runs-on: ["self-hosted","chadz"]
```

In this case, I am leveraging the self-hosted runner to run the workflow with label `chadz`.


This is fine for a single runner, but if you want keep it running, you can use the service manager to run the runner as a service.

```bash
sudo ./svc.sh install
```

```bash
sudo ./svc.sh start
```

