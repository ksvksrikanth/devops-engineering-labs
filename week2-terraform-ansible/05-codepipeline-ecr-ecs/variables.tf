variable "aws_region" {
  description = "AWS region used by this lab."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name used to prefix CI/CD resources."
  type        = string
  default     = "petclinic"
}

variable "source_repo_name" {
  description = "CodeCommit source repository name."
  type        = string
  default     = "petclinic"
}

variable "source_repo_branch" {
  description = "Branch that triggers the pipeline."
  type        = string
  default     = "main"
}

variable "image_repo_name" {
  description = "ECR repository name."
  type        = string
  default     = "petclinic"
}

variable "container_name" {
  description = "Container name used in imagedefinitions.json."
  type        = string
  default     = "petclinic"
}

variable "ecs_cluster_name" {
  description = "Existing ECS cluster name to deploy to."
  type        = string
}

variable "ecs_service_name" {
  description = "Existing ECS service name to deploy to."
  type        = string
}

variable "codebuild_compute_type" {
  description = "CodeBuild compute type."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_image" {
  description = "CodeBuild managed image."
  type        = string
  default     = "aws/codebuild/standard:7.0"
}
