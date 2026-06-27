# AWS Credentials and Environment Variables

This note covers the course steps about AWS IAM access keys and Terraform environment variables.

## Preferred Options

Use one of these safer authentication methods before creating long-lived access keys:

- AWS IAM Identity Center
- AWS CLI named profiles
- Short-lived role credentials
- GitHub Actions OIDC for CI/CD

## If You Must Create an IAM Access Key

Create the access key in the AWS console only for a dedicated learning IAM user. Do not create `aws_iam_access_key` in Terraform for this lab because the secret access key can be written into Terraform state.

Recommended handling:

- Download the key once from AWS.
- Store it in a password manager or AWS CLI profile.
- Never commit it to Git.
- Rotate and delete it after the lab.

## PowerShell Environment Variables

```powershell
# Purpose: Set the AWS access key ID for the current PowerShell session only.
$env:AWS_ACCESS_KEY_ID="REPLACE_WITH_ACCESS_KEY_ID"

# Purpose: Set the AWS secret access key for the current PowerShell session only.
$env:AWS_SECRET_ACCESS_KEY="REPLACE_WITH_SECRET_ACCESS_KEY"

# Purpose: Set the default AWS region used by Terraform and AWS CLI.
$env:AWS_REGION="ap-south-1"

# Purpose: Confirm the AWS identity that Terraform would use.
aws sts get-caller-identity
```

## Bash Environment Variables

```bash
# Purpose: Set the AWS access key ID for the current shell session only.
export AWS_ACCESS_KEY_ID="REPLACE_WITH_ACCESS_KEY_ID"

# Purpose: Set the AWS secret access key for the current shell session only.
export AWS_SECRET_ACCESS_KEY="REPLACE_WITH_SECRET_ACCESS_KEY"

# Purpose: Set the default AWS region used by Terraform and AWS CLI.
export AWS_REGION="ap-south-1"

# Purpose: Confirm the AWS identity that Terraform would use.
aws sts get-caller-identity
```

## AWS CLI Profile Alternative

```bash
# Purpose: Configure a named AWS CLI profile instead of exporting keys directly.
aws configure --profile devops-learning

# Purpose: Run Terraform with the named profile available to the AWS provider.
export AWS_PROFILE=devops-learning
```

Never place real access keys in `.tf`, `.tfvars`, README files, screenshots, or terminal recordings.
