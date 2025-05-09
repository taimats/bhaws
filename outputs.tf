output "bastion_public_ip" {
  value     = aws_instance.bastion.public_ip
  sensitive = true
}

output "app_01_private_ip" {
  value     = aws_instance.app_01.private_ip
  sensitive = true
}

output "app_02_private_ip" {
  value     = aws_instance.app_02.private_ip
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