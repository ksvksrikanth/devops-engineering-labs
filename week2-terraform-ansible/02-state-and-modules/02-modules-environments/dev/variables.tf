variable "aws_region" {
  description = "AWS region used by this lab."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project prefix for IAM users."
  type        = string
  default     = "tf-module"
}

variable "user_names" {
  description = "IAM user suffixes for the dev environment."
  type        = list(string)
  default     = ["app", "ops"]
}
