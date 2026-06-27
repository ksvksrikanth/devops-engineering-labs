terraform {
  required_version = ">= 1.5.0"
}

locals {
  normalized_project = lower(replace(var.project_name, " ", "-"))
  selected_environment = {
    name        = var.environment
    owner       = lookup(var.environment_owners, var.environment, "platform")
    cost_center = lookup(var.cost_centers, var.environment, "learning")
  }
  ordered_services = sort(var.service_names)
}

resource "terraform_data" "cli_lab" {
  input = {
    project       = local.normalized_project
    environment   = local.selected_environment
    services      = local.ordered_services
    service_count = length(local.ordered_services)
    tags = merge(var.common_tags, {
      Project     = local.normalized_project
      Environment = var.environment
      ManagedBy   = "terraform"
    })
  }
}
