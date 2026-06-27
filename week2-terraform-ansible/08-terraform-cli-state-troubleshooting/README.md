# Terraform CLI, State, and Troubleshooting

This lab fills the course-step gaps around AWS credential setup, environment variables, local state inspection, `terraform console`, `fmt`, `show`, saved plans, error recovery, and FAQ review.

It creates no AWS resources. The only managed object is `terraform_data.cli_lab`, which exists only in Terraform state and is safe for local command practice.

## Course Steps Covered

| Step | Coverage |
| --- | --- |
| Step 02 - Create AWS IAM User Access Key and Secret | Covered as safety guidance in `aws-env-setup.md`; not automated to avoid secrets in state. |
| Step 03 - Configure Terraform Environment Variables for AWS Access Keys | Covered in `aws-env-setup.md`. |
| Step 05 - Desired, Known and Actual State | Covered in `state-and-recovery.md`. |
| Step 06 - Terraform Console | Covered with console expressions in `state-and-recovery.md`. |
| Step 09 - tfstate files in depth | Covered with state inspection commands. |
| Step 10 - gitignore Terraform tfstate files | Covered by the repository `.gitignore` and notes. |
| Step 13 - fmt, show and console | Covered in the command sequence below. |
| Step 14 - Recovering from Errors | Covered in `state-and-recovery.md`. |
| Step 19 - Terraform FAQ | Covered in `terraform-faq.md`. |
| Step 35 - Update user project to use S3 Remote Backend | Covered as guidance alongside `02-state-and-modules/01-remote-state-backend`. |

## Command Sequence

```powershell
# Purpose: Move into the CLI/state troubleshooting lab.
cd <YOUR_DIRECTORY>\week2-terraform-ansible\08-terraform-cli-state-troubleshooting

# Purpose: Initialize Terraform for this local lab.
terraform init

# Purpose: Format Terraform files.
terraform fmt

# Purpose: Validate syntax and variable rules.
terraform validate

# Purpose: Create a saved execution plan.
terraform plan -out=tfplan

# Purpose: Inspect the saved plan.
terraform show tfplan

# Purpose: Apply the saved plan.
terraform apply tfplan

# Purpose: List resources currently tracked in state.
terraform state list

# Purpose: Inspect the tracked terraform_data resource.
terraform state show terraform_data.cli_lab

# Purpose: Show current outputs.
terraform output

# Purpose: Open the expression console.
terraform console
```

Exit the console with:

```text
exit
```

Destroy the local lab object:

```powershell
# Purpose: Remove the local terraform_data object from state.
terraform destroy
```

## Variable File Practice

```powershell
# Purpose: Preview changes with a variable file.
terraform plan -var-file="dev.tfvars.example"

# Purpose: Apply with a variable file.
terraform apply -var-file="dev.tfvars.example"

# Purpose: Destroy with the same variable file.
terraform destroy -var-file="dev.tfvars.example"
```

## Error Recovery Practice

Try an invalid environment:

```powershell
# Purpose: Trigger a validation error for troubleshooting practice.
terraform plan -var="environment=staging"
```

Recover with a valid value:

```powershell
# Purpose: Recover by using an allowed environment value.
terraform plan -var="environment=qa"
```

## Supporting Notes

- `aws-env-setup.md`: AWS access key and environment variable guidance.
- `state-and-recovery.md`: state, console, and recovery notes.
- `terraform-faq.md`: quick FAQ review.

## Cleanup

Do not commit generated files from this lab:

- `.terraform/`
- `.terraform.lock.hcl`
- `terraform.tfstate`
- `terraform.tfstate.backup`
- `tfplan`
- `*.tfplan`
