# Terraform FAQ Quick Review

## What Is Terraform?

Terraform is an Infrastructure as Code tool. You describe the desired infrastructure in configuration files, and Terraform plans and applies the changes needed to reach that desired state.

## What Is a Provider?

A provider is a plugin that knows how to talk to an external platform such as AWS, Vault, Kubernetes, GitHub, or many others.

## What Is a Resource?

A resource is something Terraform manages, such as an IAM user, S3 bucket, EC2 instance, security group, Vault policy, or local `terraform_data` object.

## What Is a Data Source?

A data source reads information that Terraform does not manage directly. Examples include looking up the latest AMI, default VPC, subnets, or current AWS account identity.

## What Is State?

State is Terraform's record of what it manages. Terraform uses state to compare known infrastructure with the desired configuration.

## Why Ignore State Files in Git?

State can contain sensitive values and machine-specific details. Team projects should use remote state with locking instead of committing local state files.

## What Is `terraform plan`?

`terraform plan` previews changes before they are applied. It is the safest checkpoint before creating, changing, or destroying resources.

## What Is `terraform apply`?

`terraform apply` executes the proposed changes. Use it only after reviewing the plan.

## What Is `terraform destroy`?

`terraform destroy` removes resources managed by the current Terraform state. Use it after labs to avoid cost.

## What Is `terraform console`?

`terraform console` is an interactive expression evaluator. It helps test variable references, functions, maps, lists, and outputs.

## What Is a Module?

A module is a reusable Terraform configuration. A folder with `.tf` files is a module; a root module can call child modules.

## What Is a Workspace?

A workspace is a separate state instance for the same configuration. It can be useful for learning, but many teams prefer separate folders or backends for serious environments.

## Why Avoid Creating IAM Access Keys in Terraform?

The secret access key can be stored in Terraform state. For learning, create keys manually only when required, use them through environment variables or profiles, and delete them after the lab.
