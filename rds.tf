variable "username" {
  type = string
}
variable "db_name" {
  type = string
}
resource "random_password" "db_password" {
  length = 16
}

# ----------------------
# RDSインスタンス
# ----------------------
resource "aws_db_instance" "main" {
  identifier = "${var.project}-${var.env}-postgres"

  engine            = "postgres"
  engine_version    = "16"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = false

  multi_az               = false
  availability_zone      = "ap-northeast-3a"
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false
  port                   = 5432

  deletion_protection = false
  skip_final_snapshot = false
  apply_immediately   = true

  username = var.username
  password = random_password.db_password.result
  db_name  = var.db_name

  tags = {
    Name = "${var.project}-${var.env}-postgres"
  }
}

# ----------------------
# RDSの設定関連
# ----------------------
resource "aws_db_subnet_group" "main" {
  name       = "${var.project}-${var.env}-db-subnet-group-postgres"
  subnet_ids = [aws_subnet.private_3a.id, aws_subnet.private_3b.id]
}

