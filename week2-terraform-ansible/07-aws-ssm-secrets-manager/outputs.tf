output "parameter_names" {
  description = "SSM Parameter Store parameter names created by this lab."
  value = {
    environment       = aws_ssm_parameter.app_environment.name
    feature_flag      = aws_ssm_parameter.feature_flag.name
    database_password = aws_ssm_parameter.database_password.name
  }
}

output "secrets_manager_secret_name" {
  description = "Optional Secrets Manager secret name."
  value       = var.create_secrets_manager_secret ? aws_secretsmanager_secret.app[0].name : null
}

output "read_commands" {
  description = "AWS CLI commands for reading the demo values."
  value = {
    string_parameter = "aws ssm get-parameter --name ${aws_ssm_parameter.app_environment.name} --region ${var.aws_region}"
    secure_string    = "aws ssm get-parameter --name ${aws_ssm_parameter.database_password.name} --with-decryption --region ${var.aws_region}"
    secret_value     = var.create_secrets_manager_secret ? "aws secretsmanager get-secret-value --secret-id ${aws_secretsmanager_secret.app[0].name} --region ${var.aws_region}" : "Secrets Manager is disabled by default. Set create_secrets_manager_secret=true to create it."
  }
}
