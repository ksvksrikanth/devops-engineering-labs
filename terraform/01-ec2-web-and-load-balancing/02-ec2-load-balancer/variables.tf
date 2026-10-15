variable "aws_region" {
  description = "AWS region used by this lab."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix used for AWS resources. Keep it short for ALB name limits."
  type        = string
  default     = "tf-web-lb"
}

variable "instance_count" {
  description = "Number of web instances behind the load balancer."
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count == 1
    error_message = "Keep instance_count at 1 for free-tier-oriented practice. Increase only when you intentionally accept extra cost."
  }
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Use t2.micro or t3.micro for free-tier-oriented labs."
  }
}

variable "key_name" {
  description = "Existing EC2 key pair name for SSH access."
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Your public IP in CIDR format, for example 1.2.3.4/32."
  type        = string
}
