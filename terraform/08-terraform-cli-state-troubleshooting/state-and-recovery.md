# Terraform State, Console, and Recovery Notes

This note explains the local commands used to inspect state, test expressions, and recover from common beginner errors.

## State Terms

- Desired state: what your `.tf` files say should exist.
- Known state: what Terraform last recorded in `terraform.tfstate`.
- Actual state: what really exists in the provider or local runtime.

Terraform compares desired, known, and actual state during `plan`.

## Safe State Inspection Commands

```bash
# Purpose: Show all resources tracked in the current state.
terraform state list

# Purpose: Show one tracked resource in detail.
terraform state show terraform_data.cli_lab

# Purpose: Show current output values from state.
terraform output

# Purpose: Show the full current state in human-readable form.
terraform show
```

## Console Practice

Run:

```bash
# Purpose: Start Terraform's expression console.
terraform console
```

Try these expressions:

```hcl
# Purpose: Read the currently selected environment variable.
var.environment

# Purpose: Sort the service list.
sort(var.service_names)

# Purpose: Look up an owner by environment.
lookup(var.environment_owners, var.environment, "platform")

# Purpose: Preview the normalized project name.
lower(replace(var.project_name, " ", "-"))

# Purpose: Merge generated tags with common tags.
merge(var.common_tags, { Environment = var.environment })
```

Exit the console:

```text
exit
```

## Common Errors and Recovery

### Formatting Error

Symptom:

```text
terraform fmt -check
```

shows files that are not formatted.

Fix:

```bash
# Purpose: Format Terraform files in the current folder.
terraform fmt
```

### Validation Error

Symptom:

```text
Error: Invalid value for variable
```

Fix:

```bash
# Purpose: Re-run validation after correcting the variable value.
terraform validate
```

Example recovery:

```bash
# Purpose: This fails because staging is not an allowed environment.
terraform plan -var="environment=staging"

# Purpose: This succeeds because qa is allowed.
terraform plan -var="environment=qa"
```

### State Lock or Interrupted Command

If a local run is interrupted, first inspect whether another Terraform command is still running. Avoid manually editing state files.

```bash
# Purpose: Re-run plan to check whether Terraform can read state normally.
terraform plan
```

Use `terraform force-unlock` only when you fully understand the lock ID and are sure no Terraform process is still running.

### Drift Practice

This no-cloud lab cannot demonstrate AWS drift directly, but the workflow is the same:

```bash
# Purpose: Refresh state and show whether actual infrastructure differs from configuration.
terraform plan
```

For AWS labs, drift can happen when a resource is changed manually in the AWS console after Terraform creates it.

## State Safety

- Do not commit `terraform.tfstate`.
- Do not commit `terraform.tfstate.backup`.
- Do not commit saved plans such as `tfplan`.
- Do not edit state files by hand.
- Use remote state with locking for team projects.
