variable "project_name" {
  description = "Name used in the workspace demo output."
  type        = string
  default     = "workspace-demo"
}

variable "backend_addresses" {
  description = "Backend IP addresses rendered through a template."
  type        = list(string)
  default     = ["10.0.0.10", "10.0.0.11"]
}

variable "backend_port" {
  description = "Backend port rendered through a template."
  type        = number
  default     = 8080
}
