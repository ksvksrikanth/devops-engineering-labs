output "workspace_name" {
  description = "Active Terraform workspace."
  value       = terraform_data.workspace_demo.output.workspace_name
}

output "app_name" {
  description = "Workspace-aware application name."
  value       = terraform_data.workspace_demo.output.app_name
}

output "rendered_backends" {
  description = "Template-rendered backend configuration."
  value       = terraform_data.workspace_demo.output.rendered_backends
}
