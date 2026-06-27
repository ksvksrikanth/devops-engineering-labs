variable "aws_region" {
  description = "AWS region used by this lab."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix used for parameter and secret names."
  type        = string
  default     = "tf-secrets-lab"
}

variable "environment" {
  description = "Environment name used in paths and tags."
  type        = string
  default     = "dev"
}

variable "application_name" {
  description = "Application name used in paths."
  type        = string
  default     = "sample-api"
}

variable "enable_demo_feature" {
  description = "Demo feature flag stored in Parameter Store."
  type        = bool
  default     = true
}

variable "demo_database_password" {
  description = "Demo password stored as a Standard SecureString parameter."
  type        = string
  sensitive   = true
}

variable "create_secrets_manager_secret" {
  description = "Create an AWS Secrets Manager secret. Defaults false because Secrets Manager is billable outside eligible free-tier credits."
  type        = bool
  default     = false
}

variable "demo_secret_username" {
  description = "Optional demo username stored in Secrets Manager when enabled."
  type        = string
  default     = "appuser"
}

variable "demo_secret_password" {
  description = "Optional demo password stored in Secrets Manager when enabled."
  type        = string
  sensitive   = true
  default     = "change-me-only-for-demo"
}
