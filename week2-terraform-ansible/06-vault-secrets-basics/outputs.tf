output "secret_path" {
  description = "Vault KV v2 secret path."
  value       = "${vault_mount.kv.path}/data/${var.environment}/${var.application_name}"
}

output "policy_name" {
  description = "Vault policy name that can read the demo secret."
  value       = vault_policy.app_read.name
}
