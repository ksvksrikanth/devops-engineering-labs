resource "aws_iam_user" "this" {
  name = "${var.project_name}-${var.environment}-${var.user_name}"

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
