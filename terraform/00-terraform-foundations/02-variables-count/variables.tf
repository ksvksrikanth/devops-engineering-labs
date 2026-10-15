variable "aws_region" {
  description = "AWS region used by this lab."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix for generated IAM user names."
  type        = string
  default     = "tf-count-user"
}

variable "environment" {
  description = "Environment name used in tags and resource names."
  type        = string
  default     = "dev"
}

variable "user_count" {
  description = "Number of IAM users to create."
  type        = number
  default     = 3

  validation {
    condition     = var.user_count > 0 && var.user_count <= 5
    error_message = "user_count must be between 1 and 5 for this lab."
  }
}
