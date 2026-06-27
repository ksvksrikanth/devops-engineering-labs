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
  unique_user_names = toset(var.user_names)
  common_tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = var.project_name
  }
}

resource "aws_iam_user" "users" {
  for_each = local.unique_user_names
  name     = "${var.project_name}-${var.environment}-${each.key}"

  tags = merge(local.common_tags, {
    Owner = lookup(var.user_owners, each.key, "platform")
  })
}
