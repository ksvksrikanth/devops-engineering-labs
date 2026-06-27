variable "aws_region" {
  description = "AWS region used by this lab."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project prefix for IAM users."
  type        = string
  default     = "tf-collections"
}

variable "environment" {
  description = "Environment tag value."
  type        = string
  default     = "dev"
}

variable "user_names" {
  description = "List of user suffixes. Duplicates are removed with toset."
  type        = list(string)
  default     = ["alice", "bob", "alice"]
}

variable "user_owners" {
  description = "Map of user suffix to owner tag."
  type        = map(string)
  default = {
    alice = "devops"
    bob   = "cloud"
  }
}
