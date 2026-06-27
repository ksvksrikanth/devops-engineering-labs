# AWS SSM Parameter Store and Secrets Manager

This lab creates small secret/configuration examples with Terraform.

Default behavior:

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

Read output commands:

```powershell
terraform output read_commands
```

Destroy:

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

## Learning Focus

- `aws_ssm_parameter`
- `String` vs `SecureString` parameters
- Standard Parameter Store tier
- Optional `aws_secretsmanager_secret`
- Optional `aws_secretsmanager_secret_version`
- Sensitive Terraform variables
- Avoiding committed `.tfvars` files for secrets
