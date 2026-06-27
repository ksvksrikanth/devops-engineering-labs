output "bucket_name" {
  description = "Created S3 bucket name."
  value       = aws_s3_bucket.lab.id
}

output "vpc_id" {
  description = "Created VPC ID."
  value       = aws_vpc.lab.id
}
