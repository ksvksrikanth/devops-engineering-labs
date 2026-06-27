output "iam_users" {
  description = "IAM users created with for_each."
  value = {
    for name, user in aws_iam_user.users : name => user.arn
  }
}
