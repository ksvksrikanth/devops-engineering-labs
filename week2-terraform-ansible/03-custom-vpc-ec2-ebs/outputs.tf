output "vpc_id" {
  description = "Custom VPC ID."
  value       = aws_vpc.lab.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = { for name, subnet in aws_subnet.public : name => subnet.id }
}

output "web_public_ip" {
  description = "EC2 public IP."
  value       = aws_instance.web.public_ip
}

output "extra_volume_id" {
  description = "Attached EBS volume ID."
  value       = aws_ebs_volume.extra.id
}
