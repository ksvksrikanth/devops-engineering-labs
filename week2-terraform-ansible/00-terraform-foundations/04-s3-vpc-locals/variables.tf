variable "aws_region" {
  description = "AWS region used by this lab."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix used for resource names."
  type        = string
  default     = "tf-locals"
}

variable "environment" {
  description = "Environment name used in names and tags."
  type        = string
  default     = "dev"
}

variable "bucket_suffix" {
  description = "Globally unique S3 bucket suffix. Override this before apply."
  type        = string
  default     = "replace-me-12345"
}

variable "vpc_cidr" {
  description = "CIDR block for the lab VPC."
  type        = string
  default     = "10.20.0.0/16"
}
