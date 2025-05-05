# ----------------------
# 踏み台サーバー用
# ----------------------
resource "aws_security_group" "bastion" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-sg-bastion"
  }
}

resource "aws_security_group_rule" "bastion_in_ssh" {
  security_group_id = aws_security_group.bastion.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion_out_for_app" {
  security_group_id        = aws_security_group.bastion.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.app.id
}

# ----------------------
# ロードバランサー用
# ----------------------
resource "aws_security_group" "alb" {
  name   = "${var.project}-${var.env}-sg-alb"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "alb_in_http" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_in_https" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

# ----------------------
# APサーバー用
# ----------------------
resource "aws_security_group" "app" {
  name   = "${var.project}-${var.env}-sg-app"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "app_in_from_bastion" {
  security_group_id        = aws_security_group.app.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "app_in_from_alb" {
  security_group_id        = aws_security_group.app.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8080
  to_port                  = 8080
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "app_out_https" {
  security_group_id = aws_security_group.app.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "app_out_for_db" {
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
}

resource "aws_security_group_rule" "db_in_from_app" {
  security_group_id        = aws_security_group.db.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.app.id
}
