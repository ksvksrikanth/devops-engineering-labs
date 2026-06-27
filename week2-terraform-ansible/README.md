# Week 2: Terraform and Infrastructure as Code

This folder is a hands-on Terraform learning portfolio that progresses from core Terraform syntax to CLI practice, state troubleshooting, EC2, load balancing, remote state, modules, custom networking, ECS Fargate, RDS, ECR, SSM Parameter Store, Secrets Manager, Vault, and CI/CD delivery.

## Skills Demonstrated

- Initializing Terraform projects with the AWS provider
- Creating IAM, S3, VPC, EC2, EBS, DynamoDB, ECS, ECR, RDS, SSM, Secrets Manager, CodeBuild, CodePipeline, and load balancer resources
- Using variables, validation, locals, outputs, lists, sets, maps, `count`, and `for_each`
- Practicing `terraform fmt`, `show`, `console`, saved plans, state inspection, and error recovery
- Rendering EC2 user data with `templatefile`
- Reading AWS data sources such as AMIs, VPCs, subnets, availability zones, and caller identity
- Creating reusable local modules for multiple environments
- Preparing an S3 and DynamoDB remote state backend
- Running container workloads on ECS Fargate behind an Application Load Balancer
- Building a CodeCommit, CodeBuild, ECR, and CodePipeline delivery workflow for ECS
- Installing Docker on EC2 for the Week 3 container workflow
- Keeping Terraform state, plans, private keys, and provider cache folders out of Git

## Portfolio Structure

```text
week2-terraform-ansible/
|-- 00-terraform-foundations/
|   |-- 01-iam-basic-resource/
|   |-- 02-variables-count/
|   |-- 03-lists-sets-maps/
|   |-- 04-s3-vpc-locals/
|   `-- 05-workspaces-plans-graph/
|-- 01-ec2-web-and-load-balancing/
|   |-- 01-ec2-web-server/
|   `-- 02-ec2-load-balancer/
|-- 02-state-and-modules/
|   |-- 01-remote-state-backend/
|   `-- 02-modules-environments/
|-- 03-custom-vpc-ec2-ebs/
|-- 04-ecs-fargate-rds-platform/
|-- 05-codepipeline-ecr-ecs/
|-- 06-vault-secrets-basics/
|-- 07-aws-ssm-secrets-manager/
|-- 08-terraform-cli-state-troubleshooting/
|-- terraform-ec2-docker/
`-- README.md
```

## Projects

### 00 - Terraform Foundations

Location: `00-terraform-foundations`

This folder groups the small beginner labs together so the basic language features are easy to compare side by side.

| Sub-lab | Purpose |
| --- | --- |
| `01-iam-basic-resource` | Creates one IAM user with provider configuration, tags, variables, and outputs. |
| `02-variables-count` | Creates multiple IAM users using a numeric variable and `count`. |
| `03-lists-sets-maps` | Creates IAM users with `for_each`, `toset`, maps, `lookup`, and merged tags. |
| `04-s3-vpc-locals` | Creates a private versioned S3 bucket and VPC using locals for naming and tags. |
| `05-workspaces-plans-graph` | Demonstrates workspaces, `terraform_data`, `templatefile`, saved plans, and graph output with no AWS resources. |

```powershell
cd <YOUR_DIRECTORY>\week2-terraform-ansible\00-terraform-foundations\01-iam-basic-resource
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

For the S3 sub-lab, override the bucket suffix because S3 bucket names are globally unique:

```powershell
cd <YOUR_DIRECTORY>\week2-terraform-ansible\00-terraform-foundations\04-s3-vpc-locals
terraform plan -var="bucket_suffix=<UNIQUE_SUFFIX>"
terraform apply -var="bucket_suffix=<UNIQUE_SUFFIX>"
terraform destroy -var="bucket_suffix=<UNIQUE_SUFFIX>"
```

Learning focus:

- `terraform` and `provider` blocks
- AWS provider version constraints
- Variables, validation, locals, and outputs
- `count`, `for_each`, list, set, and map types
- Modern AWS S3 resources for versioning and public access blocking
- Workspaces, saved plans, and dependency graph generation

Workspace and graph practice:

```powershell
cd <YOUR_DIRECTORY>\week2-terraform-ansible\00-terraform-foundations\05-workspaces-plans-graph
terraform init
terraform workspace new qa
terraform plan -out=tfplan
terraform show tfplan
terraform graph > graph.dot
terraform apply tfplan
terraform destroy
terraform workspace select default
terraform workspace delete qa
```

### 01 - EC2 Web and Load Balancing

Location: `01-ec2-web-and-load-balancing`

This folder combines the default-VPC EC2 web examples: one simple web server and one load-balanced web tier.

| Sub-lab | Purpose |
| --- | --- |
| `01-ec2-web-server` | Creates an Amazon Linux EC2 instance, installs Apache with user data, and exposes a web page. |
| `02-ec2-load-balancer` | Creates one free-tier-oriented EC2 web server by default and places it behind an Application Load Balancer. |

```powershell
cd <YOUR_DIRECTORY>\week2-terraform-ansible\01-ec2-web-and-load-balancing\01-ec2-web-server
terraform init
terraform plan -var="key_name=YOUR_KEY_PAIR" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
terraform apply -var="key_name=YOUR_KEY_PAIR" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
terraform destroy -var="key_name=YOUR_KEY_PAIR" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
```

Learning focus:

- AMI, VPC, and subnet data sources
- EC2 user data and `templatefile`
- Security groups
- ALB listeners, target groups, target attachments, and health checks

### 02 - State and Modules

Location: `02-state-and-modules`

This folder groups the Terraform project-organization topics: remote state and reusable modules.

| Sub-lab | Purpose |
| --- | --- |
| `01-remote-state-backend` | Creates an encrypted S3 bucket and DynamoDB lock table for Terraform remote state. |
| `02-modules-environments` | Defines a reusable IAM user module and calls it from separate `dev` and `qa` root modules. |

```powershell
cd <YOUR_DIRECTORY>\week2-terraform-ansible\02-state-and-modules\01-remote-state-backend
terraform init
terraform plan -var="account_alias=<UNIQUE_ALIAS>"
terraform apply -var="account_alias=<UNIQUE_ALIAS>"
terraform output backend_block_example
```

Module example:

```powershell
cd <YOUR_DIRECTORY>\week2-terraform-ansible\02-state-and-modules\02-modules-environments\dev
terraform init
terraform plan
terraform apply
terraform destroy
```

Learning focus:

- Why state should not be committed to Git
- S3 versioning and encryption for state
- DynamoDB state locking
- Local modules, module inputs, and module outputs
- Environment-specific root modules

### 03 - Custom VPC, EC2, and EBS

Location: `03-custom-vpc-ec2-ebs`

Creates a custom VPC, public subnets, route table, internet gateway, EC2 instance, SSH key pair, and attached EBS volume.

```powershell
cd <YOUR_DIRECTORY>\week2-terraform-ansible\03-custom-vpc-ec2-ebs
terraform init
terraform plan -var="public_key_path=$HOME\.ssh\id_rsa.pub" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
terraform apply -var="public_key_path=$HOME\.ssh\id_rsa.pub" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
terraform destroy -var="public_key_path=$HOME\.ssh\id_rsa.pub" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
```

Learning focus:

- Custom networking
- `for_each` with map objects
- Internet gateways and route associations
- EC2 key pairs from a public key file
- EBS volume attachment

### 04 - ECS Fargate, ALB, ECR, and RDS Platform

Location: `04-ecs-fargate-rds-platform`

Creates a complete container runtime platform: custom VPC, public and private subnets, ECR repository, Application Load Balancer, ECS Fargate cluster and service, CloudWatch logs, SSM SecureString parameter, and private MySQL RDS instance.

```powershell
cd <YOUR_DIRECTORY>\week2-terraform-ansible\04-ecs-fargate-rds-platform
terraform init
terraform plan -var="db_password=REPLACE_WITH_STRONG_PASSWORD"
terraform apply -var="db_password=REPLACE_WITH_STRONG_PASSWORD"
terraform destroy -var="db_password=REPLACE_WITH_STRONG_PASSWORD"
```

Learning focus:

- ECS Fargate service architecture
- ALB to ECS target groups with `target_type = "ip"`
- ECR repositories with image scanning
- RDS subnet groups and private database access
- SSM SecureString parameters for application secrets
- Free-tier-oriented RDS and smallest practical Fargate defaults

Cost note: this lab is constrained for a new-account/free-plan learning posture: NAT Gateway is blocked, RDS is limited to `db.t3.micro` or `db.t4g.micro` with up to 20 GiB, Fargate defaults to `256` CPU and `512` MiB memory, and task count defaults to `1`. ALB, RDS, Fargate, ECR, SSM, and CloudWatch usage should still be checked against your account's current free-plan credits and monthly limits before apply.

### 05 - CodePipeline, CodeBuild, ECR, and ECS Deployment

Location: `05-codepipeline-ecr-ecs`

Creates a CI/CD pipeline around an existing ECS service. It provisions CodeCommit source, CodeBuild Docker build, ECR image repository, encrypted S3 artifact bucket, CodePipeline stages, and an EventBridge rule that starts the pipeline when the source branch changes.

```powershell
cd <YOUR_DIRECTORY>\week2-terraform-ansible\05-codepipeline-ecr-ecs
terraform init
terraform plan -var="ecs_cluster_name=YOUR_CLUSTER" -var="ecs_service_name=YOUR_SERVICE"
terraform apply -var="ecs_cluster_name=YOUR_CLUSTER" -var="ecs_service_name=YOUR_SERVICE"
terraform destroy -var="ecs_cluster_name=YOUR_CLUSTER" -var="ecs_service_name=YOUR_SERVICE"
```

Learning focus:

- ECR as a container image registry
- CodeBuild Docker builds with `buildspec.yml`
- `imagedefinitions.json` for ECS deployment actions
- S3 artifact stores
- CodePipeline source, build, and deploy stages
- EventBridge triggers for source branch updates

This lab can target the ECS cluster and service names output by `04-ecs-fargate-rds-platform`.

Cost note: this is an advanced CI/CD reference lab. CodeBuild has a free tier for limited build minutes, but CodePipeline and related artifacts may not be fully covered outside AWS free-plan credits. Use `terraform plan` for study and apply only after checking your account's billing/free-tier status.

### 06 - Vault Secrets Basics

Location: `06-vault-secrets-basics`

Creates a Vault KV v2 mount, a demo secret, and a Vault policy that can read that secret. This is a no-AWS lab and is intended for local Vault dev mode.

Start Vault locally in a separate terminal:

```powershell
vault server -dev -dev-root-token-id=root
```

Run Terraform:

```powershell
cd <YOUR_DIRECTORY>\week2-terraform-ansible\06-vault-secrets-basics
$env:VAULT_TOKEN="root"
terraform init
terraform plan -var="demo_password=local-dev-password"
terraform apply -var="demo_password=local-dev-password"
terraform destroy -var="demo_password=local-dev-password"
```

Learning focus:

- Vault provider configuration
- KV v2 secrets engine
- Writing demo secrets through Terraform
- Vault policies
- Why real production secrets should not be hardcoded into `.tf` or `.tfvars` files

### 07 - AWS SSM Parameter Store and Secrets Manager

Location: `07-aws-ssm-secrets-manager`

Creates small configuration and secret examples with AWS Systems Manager Parameter Store. By default it creates only Standard SSM parameters, including one `SecureString`. AWS Secrets Manager is included as an optional resource but disabled by default because it is billable outside eligible AWS Free Tier credits.

```powershell
cd <YOUR_DIRECTORY>\week2-terraform-ansible\07-aws-ssm-secrets-manager
terraform init
terraform plan -var="demo_database_password=local-demo-password"
terraform apply -var="demo_database_password=local-demo-password"
terraform output read_commands
terraform destroy -var="demo_database_password=local-demo-password"
```

Optional Secrets Manager practice:

```powershell
terraform apply -var="demo_database_password=local-demo-password" -var="create_secrets_manager_secret=true" -var="demo_secret_password=local-secret-password"
terraform destroy -var="demo_database_password=local-demo-password" -var="create_secrets_manager_secret=true" -var="demo_secret_password=local-secret-password"
```

Learning focus:

- Standard SSM parameters
- `String` and `SecureString`
- Optional Secrets Manager secret and secret version
- Sensitive input variables
- Keeping secret values out of committed `.tfvars` files

Cost note: Standard Parameter Store parameters are listed by AWS as no additional charge. Secrets Manager is priced per secret and API calls, though eligible new accounts may use AWS Free Tier credits.

### 08 - Terraform CLI, State, and Troubleshooting

Location: `08-terraform-cli-state-troubleshooting`

Creates no AWS resources. This lab uses the built-in `terraform_data` resource to practice CLI commands, saved plans, `terraform show`, `terraform console`, state inspection, variable files, validation failures, and recovery workflows. It also documents safe AWS access-key handling without creating access keys in Terraform state.

```powershell
cd <YOUR_DIRECTORY>\week2-terraform-ansible\08-terraform-cli-state-troubleshooting
terraform init
terraform fmt
terraform validate
terraform plan -out=tfplan
terraform show tfplan
terraform apply tfplan
terraform state list
terraform state show terraform_data.cli_lab
terraform console
terraform destroy
```

Learning focus:

- AWS credential environment variables and access-key safety
- Desired, known, and actual state
- Local state inspection with `terraform state`
- `terraform console` expression practice
- `terraform fmt`, `validate`, `show`, saved plans, and outputs
- Common beginner error recovery
- Terraform FAQ review

### Existing Lab - EC2 Docker Host

Location: `terraform-ec2-docker`

Creates an Ubuntu EC2 instance with Docker installed, plus the IAM role needed to pull images from Amazon ECR. This connects Week 2 Terraform infrastructure with the Week 3 Docker exercises.

```powershell
cd <YOUR_DIRECTORY>\week2-terraform-ansible\terraform-ec2-docker
terraform init
terraform plan -var="key_name=YOUR_KEY_PAIR" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
terraform apply -var="key_name=YOUR_KEY_PAIR" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
terraform destroy -var="key_name=YOUR_KEY_PAIR" -var="allowed_ssh_cidr=YOUR_PUBLIC_IP/32"
```

Learning focus:

- EC2 provisioning for container hosting
- IAM instance profiles
- ECR read-only permissions
- User data for Docker installation
- Manual GitHub Actions apply and destroy workflows

## Terraform Workflow

Use this command sequence inside each lab:

```powershell
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

`terraform plan` is the checkpoint before spending money. Review it carefully before `apply`.

## State and Secrets

Do not commit these files:

- `.terraform/`
- `.terraform.lock.hcl`
- `terraform.tfstate`
- `terraform.tfstate.backup`
- `*.tfplan`
- `terraform.tfvars`
- private keys such as `*.pem` or `dovekey`

The source backup contained local state files, local tfvars, and private key material. Those were not copied into this learning repository.

## Free-Tier Posture

The AWS labs are free-tier-oriented, not a guarantee of zero cost. AWS free-tier eligibility depends on account age, region, free-plan credits, service quotas, and monthly usage already consumed.

Guardrails applied in these labs:

- EC2 defaults to `t3.micro`, with validation allowing only `t2.micro` or `t3.micro`.
- The ALB lab uses one EC2 instance by default to avoid doubling monthly EC2 hours.
- EBS extra volume size is limited to 1-5 GiB in the custom VPC lab.
- RDS is limited to `db.t3.micro` or `db.t4g.micro` and up to 20 GiB.
- NAT Gateway is blocked because it is billed hourly and by data processed.
- Vault and workspace/graph labs create no AWS resources.
- CLI/state troubleshooting lab creates no AWS resources.
- SSM Parameter Store lab defaults to Standard parameters only.
- Secrets Manager resources are disabled by default.
- `terraform.tfvars`, state files, plans, provider caches, and private keys are ignored.

Check your AWS Billing and Free Tier pages before applying ALB, ECS/Fargate, RDS, CodeBuild, or CodePipeline labs.

## Cost and Cleanup

Most AWS labs create resources. Some resources can cost money while running, especially EC2, EBS, S3, DynamoDB, RDS, ECS/Fargate, CodePipeline, CodeBuild, and load balancers.

Run cleanup from the same folder after testing:

```powershell
terraform destroy
```

For labs that required variables during apply, pass the same variable values to destroy.

## Evaluation Notes

Strengths demonstrated by this portfolio:

- Cleaner top-level layout with related labs grouped together
- Clear progression from first resource to reusable modules and application platforms
- Modern Terraform syntax and AWS provider 5.x-compatible resources
- Additional CLI topics covered through workspace, saved-plan, graph, state, and Vault labs
- Safer SSH access by requiring `YOUR_PUBLIC_IP/32`
- Free-tier-oriented validations for EC2, EBS, RDS, and NAT Gateway avoidance
- Remote backend preparation instead of committing state
- Stronger connection between infrastructure provisioning and the Docker deployment workflow

Lab considerations:

- IAM user labs are educational. In production, prefer roles and federated identities.
- The EC2 labs assume a default VPC exists in the selected AWS region.
- The ALB, ECS, RDS, CodeBuild, and CodePipeline labs can create billable resources; destroy them immediately after testing.
- The backend lab creates resources for other Terraform projects but does not automatically migrate their state.
- Public HTTP is open for learning convenience. Production systems should use HTTPS and tighter ingress rules.
