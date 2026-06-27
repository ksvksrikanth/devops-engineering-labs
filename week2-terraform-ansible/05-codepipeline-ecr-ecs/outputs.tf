output "source_repo_clone_url_http" {
  description = "CodeCommit HTTPS clone URL."
  value       = aws_codecommit_repository.source.clone_url_http
}

output "ecr_repository_url" {
  description = "ECR repository URL."
  value       = aws_ecr_repository.app.repository_url
}

output "pipeline_name" {
  description = "CodePipeline name."
  value       = aws_codepipeline.app.name
}

output "pipeline_url" {
  description = "AWS console URL for the pipeline."
  value       = "https://console.aws.amazon.com/codepipeline/home?region=${var.aws_region}#/view/${aws_codepipeline.app.name}"
}
