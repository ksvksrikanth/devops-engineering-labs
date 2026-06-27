terraform {
  required_version = ">= 1.5.0"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}

provider "vault" {
  address = var.vault_address
}

resource "vault_mount" "kv" {
  path        = var.kv_mount_path
  type        = "kv"
  description = "KV v2 secrets engine for Terraform learning labs"

  options = {
    version = "2"
  }
}

resource "vault_kv_secret_v2" "app_config" {
  mount = vault_mount.kv.path
  name  = "${var.environment}/${var.application_name}"

  data_json = jsonencode({
    username = var.demo_username
    password = var.demo_password
  })
}

resource "vault_policy" "app_read" {
  name = "${var.application_name}-${var.environment}-read"

  policy = <<EOT
path "${vault_mount.kv.path}/data/${var.environment}/${var.application_name}" {
  capabilities = ["read"]
}
EOT
}
