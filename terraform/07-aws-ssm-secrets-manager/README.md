# AWS SSM Parameter Store and Secrets Manager

Use this lab to practice storing application settings and a demo password in AWS with Terraform. Start with the Parameter Store examples, then try Secrets Manager if you want to compare the two.

With the default settings, the lab:

- Creates three AWS Systems Manager Parameter Store parameters.
- Uses only `Standard` tier parameters.
- Creates one `SecureString` parameter for a demo password.
- Does not create an AWS Secrets Manager secret unless explicitly enabled.

Secrets Manager is optional because it is billed per secret and API call outside eligible AWS Free Tier credits. Parameter Store standard parameters are the safer default for a free-tier-oriented lab.

## Commands

```powershell
terraform init
terraform fmt
terraform validate
terraform plan -var="demo_database_password=local-demo-password"
terraform apply -var="demo_database_password=local-demo-password"
```

To see the commands for reading the values:

```powershell
terraform output read_commands
```

When you are finished, remove the lab resources:

```powershell
terraform destroy -var="demo_database_password=local-demo-password"
```

## Optional Secrets Manager Secret

Enable this only after checking your AWS billing/free-tier status:

```powershell
terraform plan -var="demo_database_password=local-demo-password" -var="create_secrets_manager_secret=true" -var="demo_secret_password=local-secret-password"
terraform apply -var="demo_database_password=local-demo-password" -var="create_secrets_manager_secret=true" -var="demo_secret_password=local-secret-password"
terraform destroy -var="demo_database_password=local-demo-password" -var="create_secrets_manager_secret=true" -var="demo_secret_password=local-secret-password"
```

## What to practice

- `aws_ssm_parameter`
- `String` vs `SecureString` parameters
- Standard Parameter Store tier
- Optional `aws_secretsmanager_secret`
- Optional `aws_secretsmanager_secret_version`
- Sensitive Terraform variables
- Avoiding committed `.tfvars` files for secrets
