output "load_balancer_dns" {
  description = "Application Load Balancer DNS name."
  value       = aws_lb.web.dns_name
}

output "web_instance_public_ips" {
  description = "Public IPs of the EC2 instances."
  value       = aws_instance.web[*].public_ip
}
