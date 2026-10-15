# Create AWS EC2 Using Terraform

In this lab, you will use Terraform to create an Ubuntu EC2 instance and run the Flask API on it. The startup script installs Docker, and the Terraform configuration sets up SSH and application access.

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

Downloads the AWS provider plugin and prepares the folder as a Terraform working directory.

Format Terraform files:

```bash
terraform fmt
```

Formats Terraform files consistently so the code is clean and readable.

Validate Terraform configuration:

```bash
terraform validate
```

Checks whether the Terraform syntax and provider configuration are valid.

Preview the AWS resources:

```bash
terraform plan -var="name_prefix=docker-lab-test" -var="key_name=YOUR_KEY_PAIR" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
```

Shows what Terraform will create before it actually changes AWS.

Create the EC2 instance and security group:

```bash
terraform apply -var="name_prefix=docker-lab-test" -var="key_name=YOUR_KEY_PAIR" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
```

Creates the EC2 instance and security group in AWS.

Connect to the EC2 instance:

```bash
ssh -i your-key.pem ubuntu@EC2_PUBLIC_IP
```

Connects to the EC2 instance so you can run Docker deployment commands.

Confirm Docker is installed:

```bash
docker --version
sudo docker ps
```

Confirms Docker is installed and the Docker daemon is running.

## Deploy Container on Terraform-created EC2

```bash
aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin 720643158823.dkr.ecr.ap-south-1.amazonaws.com
sudo docker pull YOUR_ECR_REPOSITORY_URI:latest
sudo docker run -d --name flask-api -p 5000:5000 YOUR_ECR_REPOSITORY_URI:latest
```

Pulls your image from ECR and runs it on EC2 with port mapping for browser access.

Important: the ECR login username must be `AWS`. Do not use your IAM username. The EC2 instance gets ECR pull permissions from the IAM role created by Terraform.

## Destroy After Testing

```bash
terraform destroy -var="name_prefix=docker-lab-test" -var="key_name=YOUR_KEY_PAIR" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
```

Deletes the EC2 instance and security group to avoid unnecessary AWS cost.

## GitHub Actions Workflows

The repository includes two Terraform GitHub Actions workflows:

- `.github/workflows/terraform-ec2-docker.yml`
- `.github/workflows/terraform-ec2-docker-destroy.yml`

Both workflows run manually from the GitHub Actions tab using `workflow_dispatch`.

### Apply Workflow

Use `Terraform EC2 Docker Apply` to create the EC2 instance.

The workflow runs these steps:

- `terraform fmt -check`
- `terraform init`
- `terraform validate`
- `terraform plan -out=tfplan`
- `terraform apply -auto-approve tfplan`
- Uploads `terraform.tfstate` as a workflow artifact named `terraform-ec2-docker-state`
- Prints the EC2 public IP, app URL, and SSH command in the workflow logs

Provide these values when you start the workflow:

- `key_name`: existing AWS EC2 key pair name
- `allowed_ssh_cidr`: your public IP in CIDR format, for example `1.2.3.4/32`

The workflow automatically uses `docker-lab-GITHUB_RUN_ID` as the Terraform `name_prefix`, so each apply run creates uniquely named AWS resources and avoids collisions with older lab resources.

After the apply job completes, connect to EC2 and deploy the Flask API container:

```bash
ssh -i your-key.pem ubuntu@EC2_PUBLIC_IP
aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin 720643158823.dkr.ecr.ap-south-1.amazonaws.com
sudo docker pull YOUR_ECR_REPOSITORY_URI:latest
sudo docker run -d --name flask-api -p 5000:5000 YOUR_ECR_REPOSITORY_URI:latest
```

Open the app URL from the workflow logs to test the API.

### Destroy Workflow

Use `Terraform EC2 Docker Destroy` only after you finish testing the container.

The workflow runs these steps:

- Downloads the `terraform-ec2-docker-state` artifact from the apply workflow run
- `terraform init`
- `terraform plan -destroy -out=tfdestroyplan`
- `terraform apply -auto-approve tfdestroyplan`

Provide these values when you start the workflow:

- `apply_run_id`: the workflow run ID from the successful `Terraform EC2 Docker Apply` run
- `key_name`: the same EC2 key pair name used during apply
- `allowed_ssh_cidr`: the same CIDR value used during apply

The destroy workflow automatically uses `docker-lab-APPLY_RUN_ID` as the Terraform `name_prefix`, matching the names created by the apply workflow.

To find the apply run ID, open the successful apply workflow run in GitHub Actions and copy the number from the URL.

Example URL:

```text
https://github.com/OWNER/REPOSITORY/actions/runs/1234567890
```

In this example, the `apply_run_id` is:

```text
1234567890
```

The Terraform state artifact is retained for 7 days. Run the destroy workflow before the artifact expires.

If an older apply failed before state was saved, AWS may still have leftover resources such as `docker-lab-sg`, `docker-lab-ec2-role`, or `docker-lab-ec2-profile`. Delete those old resources manually from AWS if they are no longer attached to an EC2 instance.

For production, store Terraform state in a remote backend such as S3 with DynamoDB locking. This lab uses a workflow artifact for state only to keep the exercise simple.
