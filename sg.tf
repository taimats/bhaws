# 自分のIPアドレスを動的に取得
data "http" "my_ip" {
  url = "https://api.ipify.org?format=json"

  request_headers = {
    Accept = "application/json"
  }
}

locals {
  my_ip = "${jsondecode(data.http.my_ip.response_body)["ip"]}/32"
}

# ----------------------
# 踏み台サーバー用
# ----------------------
resource "aws_security_group" "bastion" {
  name   = "${var.project}-${var.env}-sg-bastion"
  vpc_id = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress_bastion_ssh" {
  security_group_id = aws_security_group.bastion.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [local.my_ip]
}

resource "aws_security_group_rule" "egress_bastion_for_all" {
  security_group_id = aws_security_group.bastion.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# ----------------------
# ロードバランサー用
# ----------------------
resource "aws_security_group" "alb" {
  name   = "${var.project}-${var.env}-sg-alb"
  vpc_id = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress_alb_http" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_alb_https" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_alb_for_private_subnet" {
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = [aws_subnet.private_3a.cidr_block, aws_subnet.private_3c.cidr_block]
}

# ----------------------
# APサーバー用
# ----------------------
resource "aws_security_group" "app" {
  name   = "${var.project}-${var.env}-sg-app"
  vpc_id = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress_app_from_bastion" {
  security_group_id        = aws_security_group.app.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "ingress_app_from_alb" {
  security_group_id        = aws_security_group.app.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8080
  to_port                  = 8080
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "egress_app_https" {
  security_group_id = aws_security_group.app.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_app_for_db" {
  security_group_id        = aws_security_group.app.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.db.id
}

# ----------------------
# DBサーバー用
# ----------------------
resource "aws_security_group" "db" {
  name   = "${var.project}-${var.env}-sg-db"
  vpc_id = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress_db_from_bastion" {
  security_group_id        = aws_security_group.db.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "ingress_db_from_app" {
  security_group_id        = aws_security_group.db.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.app.id
}
