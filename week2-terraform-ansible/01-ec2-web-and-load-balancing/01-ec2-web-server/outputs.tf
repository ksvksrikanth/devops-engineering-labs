output "public_ip" {
  description = "EC2 public IP address."
  value       = aws_instance.web.public_ip
}

output "public_dns" {
  description = "EC2 public DNS name."
  value       = aws_instance.web.public_dns
}

output "web_url" {
  description = "HTTP URL for the web server."
  value       = "http://${aws_instance.web.public_dns}"
}
