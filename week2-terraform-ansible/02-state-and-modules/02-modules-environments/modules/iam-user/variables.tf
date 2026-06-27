variable "project_name" {
  description = "Project prefix for IAM users."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "user_name" {
  description = "User suffix."
  type        = string
}
