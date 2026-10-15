terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  name_prefix    = lower(replace(var.name_prefix, "_", "-"))
  parameter_path = "/${local.name_prefix}/${var.environment}/${var.application_name}"

  common_tags = {
    Project     = var.name_prefix
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_ssm_parameter" "app_environment" {
  name        = "${local.parameter_path}/environment"
  description = "Application environment value"
  type        = "String"
  tier        = "Standard"
  value       = var.environment

  tags = local.common_tags
}

resource "aws_ssm_parameter" "feature_flag" {
  name        = "${local.parameter_path}/feature-flags/enable-demo"
  description = "Demo feature flag stored as a standard SSM parameter"
  type        = "String"
  tier        = "Standard"
  value       = tostring(var.enable_demo_feature)

  tags = local.common_tags
}

resource "aws_ssm_parameter" "database_password" {
  name        = "${local.parameter_path}/database/password"
  description = "Demo database password stored as a SecureString parameter"
  type        = "SecureString"
  tier        = "Standard"
  value       = var.demo_database_password

  tags = local.common_tags
}

resource "aws_secretsmanager_secret" "app" {
  count = var.create_secrets_manager_secret ? 1 : 0

  name                    = "${local.name_prefix}/${var.environment}/${var.application_name}/credentials"
  description             = "Optional demo application secret"
  recovery_window_in_days = 7

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "app" {
  count = var.create_secrets_manager_secret ? 1 : 0

  secret_id = aws_secretsmanager_secret.app[0].id
  secret_string = jsonencode({
    username = var.demo_secret_username
    password = var.demo_secret_password
  })
}
