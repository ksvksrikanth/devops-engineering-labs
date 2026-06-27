variable "project_name" {
  description = "Project name used by console, plan, and state examples."
  type        = string
  default     = "Terraform CLI Lab"
}

variable "environment" {
  description = "Environment selected for this CLI/state lab."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "environment must be one of dev, qa, or prod."
  }
}

variable "service_names" {
  description = "Service names used to demonstrate list behavior."
  type        = list(string)
  default     = ["api", "worker", "web"]
}

variable "environment_owners" {
  description = "Map used to demonstrate lookup behavior in terraform console."
  type        = map(string)
  default = {
    dev  = "devops"
    qa   = "quality"
    prod = "platform"
  }
}

variable "cost_centers" {
  description = "Map used to demonstrate known values and defaults."
  type        = map(string)
  default = {
    dev  = "learning"
    qa   = "testing"
    prod = "production"
  }
}

variable "common_tags" {
  description = "Common tags merged with generated tags."
  type        = map(string)
  default = {
    Repository = "DevOps-Learning"
    Week       = "2"
  }
}
