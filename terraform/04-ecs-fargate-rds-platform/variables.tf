variable "aws_region" {
  description = "AWS region used by this lab."
  type        = string
  default     = "ap-south-1"
}

variable "stack_name" {
  description = "Name used to prefix platform resources."
  type        = string
  default     = "terraform-workshop"
}

variable "vpc_cidr" {
  description = "CIDR block for the application VPC."
  type        = string
  default     = "172.17.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to use."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "az_count must be 2 or 3 for this lab."
  }
}

variable "enable_nat_gateway" {
  description = "NAT gateways are intentionally disabled for free-tier-oriented labs."
  type        = bool
  default     = false

  validation {
    condition     = var.enable_nat_gateway == false
    error_message = "NAT Gateway is billed hourly and is not free-tier friendly. Keep enable_nat_gateway=false."
  }
}

variable "image_repo_name" {
  description = "ECR repository name for the application image."
  type        = string
  default     = "petclinic"
}

variable "image_tag" {
  description = "Container image tag to deploy."
  type        = string
  default     = "latest"
}

variable "task_family" {
  description = "ECS task family and container name."
  type        = string
  default     = "petclinic"
}

variable "container_port" {
  description = "Application container port."
  type        = number
  default     = 8080
}

variable "task_count" {
  description = "Number of ECS tasks to run."
  type        = number
  default     = 1
}

variable "fargate_cpu" {
  description = "Fargate CPU units."
  type        = number
  default     = 256
}

variable "fargate_memory" {
  description = "Fargate memory in MiB."
  type        = number
  default     = 512
}

variable "health_check_path" {
  description = "ALB target group health check path."
  type        = string
  default     = "/"
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 7
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.db_allocated_storage <= 20
    error_message = "Keep RDS storage at or below 20 GiB for free-tier-oriented practice."
  }
}

variable "db_engine_version" {
  description = "MySQL engine version."
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"

  validation {
    condition     = contains(["db.t3.micro", "db.t4g.micro"], var.db_instance_class)
    error_message = "Use db.t3.micro or db.t4g.micro for RDS free-plan eligibility."
  }
}

variable "db_name" {
  description = "Application database name."
  type        = string
  default     = "petclinic"
}

variable "db_user" {
  description = "Application database username."
  type        = string
  default     = "petclinic"
}

variable "db_password" {
  description = "Application database password. Pass this at apply time or through TF_VAR_db_password."
  type        = string
  sensitive   = true
}

variable "db_profile" {
  description = "Application profile for database-backed runtime."
  type        = string
  default     = "mysql"
}

variable "db_initialize" {
  description = "Whether the application should initialize database content."
  type        = string
  default     = "yes"
}
