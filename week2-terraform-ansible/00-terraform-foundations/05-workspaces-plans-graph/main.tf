terraform {
  required_version = ">= 1.5.0"
}

locals {
  workspace_name = terraform.workspace
  environment    = terraform.workspace == "default" ? "dev" : terraform.workspace
  app_name       = "${var.project_name}-${local.environment}"
  backend_lines = [
    for address in var.backend_addresses : "backend ${address}:${var.backend_port}"
  ]
}

resource "terraform_data" "workspace_demo" {
  input = {
    app_name       = local.app_name
    environment    = local.environment
    workspace_name = local.workspace_name
    rendered_backends = templatefile("${path.module}/backends.tpl", {
      backends = local.backend_lines
    })
  }
}
