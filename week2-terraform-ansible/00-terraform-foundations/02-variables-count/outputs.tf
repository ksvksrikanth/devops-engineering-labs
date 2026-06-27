output "iam_user_names" {
  description = "IAM users created with count."
  value       = aws_iam_user.team[*].name
}
