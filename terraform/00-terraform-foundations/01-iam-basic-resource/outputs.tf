output "iam_user_name" {
  description = "Created IAM user name."
  value       = aws_iam_user.lab_user.name
}

output "iam_user_arn" {
  description = "Created IAM user ARN."
  value       = aws_iam_user.lab_user.arn
}
