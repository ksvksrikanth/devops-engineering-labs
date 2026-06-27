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

resource "aws_iam_user" "team" {
  count = var.user_count
  name  = "${var.name_prefix}-${var.environment}-${count.index + 1}"

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
