output "app_3a_private_ip" {
  value     = aws_instance.app_3a.private_ip
  sensitive = true
}

output "app_3b_private_ip" {
  value     = aws_instance.app_3b.private_ip
  sensitive = true
}

output "db_endpoint" {
  value     = aws_db_instance.main.endpoint
  sensitive = true
}

output "db_password" {
  value     = aws_db_instance.main.password
  sensitive = true
}