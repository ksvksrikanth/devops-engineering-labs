variable "aws_region" {
  description = "AWS region used by this lab."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix used for lab resource names."
  type        = string
  default     = "tf-basics"
}

variable "environment" {
  description = "Environment label added to resource names and tags."
  type        = string
  default     = "dev"
}
