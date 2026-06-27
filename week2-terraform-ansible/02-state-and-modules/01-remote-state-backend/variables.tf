variable "aws_region" {
  description = "AWS region used by this lab."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix used for backend resources."
  type        = string
  default     = "tf-backend"
}

variable "account_alias" {
  description = "Short unique alias to keep the S3 bucket name globally unique."
  type        = string
}
