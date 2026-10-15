output "ec2_public_ip" {
  value = aws_instance.docker_lab.public_ip
}

output "app_url" {
  value = "http://${aws_instance.docker_lab.public_ip}:${var.app_port}"
}
