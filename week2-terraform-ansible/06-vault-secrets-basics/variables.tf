variable "vault_address" {
  description = "Vault server address. For local dev mode, use http://127.0.0.1:8200."
  type        = string
  default     = "http://127.0.0.1:8200"
}

variable "kv_mount_path" {
  description = "Vault KV v2 mount path."
  type        = string
  default     = "terraform-labs"
}

variable "application_name" {
  description = "Application name for the demo secret path and policy."
  type        = string
  default     = "sample-api"
}

variable "environment" {
  description = "Environment name for the secret path."
  type        = string
  default     = "dev"
}

variable "demo_username" {
  description = "Demo username stored in Vault."
  type        = string
  default     = "appuser"
}

variable "demo_password" {
  description = "Demo password stored in Vault. Use a throwaway value for local dev mode only."
  type        = string
  sensitive   = true
}
