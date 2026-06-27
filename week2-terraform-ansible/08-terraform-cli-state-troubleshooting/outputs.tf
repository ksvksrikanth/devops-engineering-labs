output "lab_summary" {
  description = "Computed values used by plan, show, console, and state exercises."
  value       = terraform_data.cli_lab.output
}

output "service_names" {
  description = "Sorted service names."
  value       = terraform_data.cli_lab.output.services
}

output "selected_owner" {
  description = "Owner selected from the environment_owners map."
  value       = terraform_data.cli_lab.output.environment.owner
}
