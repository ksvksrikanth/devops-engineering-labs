variable "aws_region" {
  default = "ap-south-1"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Your public IP in CIDR format, example: 1.2.3.4/32"
  type        = string
}

variable "app_port" {
  default = 5000
}
