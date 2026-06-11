# Create AWS EC2 Using Terraform

This lab replaces manual EC2 creation with Infrastructure as Code. It creates one Ubuntu EC2 instance, installs Docker using user data, allows SSH and application access, and lets you deploy the Flask API container.

Cost warning: use a small instance such as `t2.micro` or `t3.micro` where eligible. Destroy resources after testing.

## Folder Structure

```text
terraform-ec2-docker/
├── main.tf
├── variables.tf
├── outputs.tf
└── user_data.sh
```

## User Data

The `user_data.sh` script runs when EC2 boots. It installs Docker and AWS CLI, starts Docker, and allows the `ubuntu` user to run Docker commands.

## Terraform Commands

Initialize Terraform:

```bash
terraform init
```

Understand: downloads the AWS provider plugin and prepares the folder as a Terraform working directory.

Format Terraform files:

```bash
terraform fmt
```

Understand: formats Terraform files consistently so the code is clean and readable.

Validate Terraform configuration:

```bash
terraform validate
```

Understand: checks whether the Terraform syntax and provider configuration are valid.

Preview the AWS resources:

```bash
terraform plan -var="key_name=YOUR_KEY_PAIR" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
```

Understand: shows what Terraform will create before it actually changes AWS.

Create the EC2 instance and security group:

```bash
terraform apply -var="key_name=YOUR_KEY_PAIR" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
```

Understand: creates the EC2 instance and security group in AWS.

Connect to the EC2 instance:

```bash
ssh -i your-key.pem ubuntu@EC2_PUBLIC_IP
```

Understand: connects to the EC2 instance so you can run Docker deployment commands.

Confirm Docker is installed:

```bash
docker --version
sudo docker ps
```

Understand: confirms Docker is installed and the Docker daemon is running.

## Deploy Container on Terraform-created EC2

```bash
docker pull YOUR_ECR_REPOSITORY_URI:latest
docker run -d --name flask-api -p 5000:5000 YOUR_ECR_REPOSITORY_URI:latest
```

Understand: pulls your image from ECR and runs it on EC2 with port mapping for browser access.

## Destroy After Testing

```bash
terraform destroy -var="key_name=YOUR_KEY_PAIR" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
```

Understand: deletes the EC2 instance and security group to avoid unnecessary AWS cost.

## GitHub Actions Workflow

The repository includes `.github/workflows/terraform-ec2-docker.yml`.

Purpose: checks the Terraform code for this lab, can run a manual Terraform plan, and can run a full create-test-destroy lab flow using AWS OIDC.

The workflow runs automatically on changes to this folder and performs:

- `terraform fmt -check`
- `terraform init`
- `terraform validate`

The workflow can also be started manually with `workflow_dispatch`.

### Manual Plan Mode

Use mode `plan` to preview the EC2 resources from GitHub Actions.

This mode runs:

- `terraform plan`

Required inputs:

- `key_name`: existing AWS EC2 key pair name
- `allowed_ssh_cidr`: your public IP in CIDR format, for example `1.2.3.4/32`

### Manual Apply and Destroy Mode

Use mode `apply_destroy` to create the EC2 instance, pause while you deploy the Docker container, and then destroy the resources after you approve the final job.

This mode runs:

- `terraform apply -auto-approve`
- Uploads `terraform.tfstate` as a short-lived workflow artifact
- Prints the EC2 public IP, app URL, and SSH command in the workflow logs
- Waits at the `ec2-docker-manual-deploy` GitHub Environment before destroy
- `terraform destroy -auto-approve` after approval

After the apply job completes, connect to EC2 and deploy the Flask API container:

```bash
ssh -i your-key.pem ubuntu@EC2_PUBLIC_IP
docker pull YOUR_ECR_REPOSITORY_URI:latest
docker run -d --name flask-api -p 5000:5000 YOUR_ECR_REPOSITORY_URI:latest
```

Open the app URL from the workflow logs to test the API. When testing is complete, approve the `terraform-destroy` job in GitHub Actions.

Important: to make the workflow pause before destroy, create a GitHub Environment named `ec2-docker-manual-deploy` and configure required reviewers:

1. Go to repository `Settings`.
2. Open `Environments`.
3. Create `ec2-docker-manual-deploy`.
4. Add yourself as a required reviewer.

If this environment is not protected with a required reviewer, GitHub Actions will not pause and the destroy job may run immediately after apply.

For production, store Terraform state in a remote backend such as S3 with DynamoDB locking. This lab uses a workflow artifact for state only to keep the exercise simple.
