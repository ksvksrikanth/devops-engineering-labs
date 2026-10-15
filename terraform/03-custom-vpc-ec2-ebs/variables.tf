variable "aws_region" {
  description = "AWS region used by this lab."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix used for AWS resources."
  type        = string
  default     = "tf-vpc-lab"
}

variable "vpc_cidr" {
  description = "CIDR block for the custom VPC."
  type        = string
  default     = "10.40.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet definitions by logical name."
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {
    public-1 = {
      cidr = "10.40.1.0/24"
      az   = "ap-south-1a"
    }
    public-2 = {
      cidr = "10.40.2.0/24"
      az   = "ap-south-1b"
    }
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

variable "public_key_path" {
  description = "Path to a local SSH public key, for example ~/.ssh/id_rsa.pub."
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Your public IP in CIDR format, for example 1.2.3.4/32."
  type        = string
}

variable "extra_volume_size_gb" {
  description = "Size of the extra EBS volume."
  type        = number
  default     = 3

  validation {
    condition     = var.extra_volume_size_gb >= 1 && var.extra_volume_size_gb <= 5
    error_message = "Keep the extra EBS volume between 1 and 5 GiB for a small learning lab."
  }
}
