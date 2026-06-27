output "user_names" {
  description = "Dev IAM user names."
  value       = { for key, module_instance in module.users : key => module_instance.name }
}
