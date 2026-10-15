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

module "users" {
  for_each     = toset(var.user_names)
  source       = "../modules/iam-user"
  project_name = var.project_name
  environment  = "qa"
  user_name    = each.key
}
