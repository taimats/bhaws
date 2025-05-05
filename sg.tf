# ----------------------
# ロードバランサー用
# ----------------------
resource "aws_security_group" "elb" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-sg-elb"
  }
}
resource "aws_security_group_rule" "elb_in_http" {
  security_group_id = aws_security_group.elb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "elb_in_https" {
  security_group_id = aws_security_group.elb.id
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
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-sg-app"
  }
}
resource "aws_security_group_rule" "app_in_from_elb" {
  security_group_id        = aws_security_group.app.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8000
  to_port                  = 8000
  cidr_blocks              = ["0.0.0.0/0"]
  source_security_group_id = aws_security_group.elb.id
}
resource "aws_security_group_rule" "app_in_from_db" {
  security_group_id        = aws_security_group.app.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8000
  to_port                  = 8000
  cidr_blocks              = ["0.0.0.0/0"]
  source_security_group_id = aws_security_group.db.id
}
resource "aws_security_group_rule" "app_out" {
  security_group_id = aws_security_group.app.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks       = ["0.0.0.0/0"]
}

# ----------------------
# DBサーバー用
# ----------------------
resource "aws_security_group" "db" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-sg-db"
  }
}
resource "aws_security_group_rule" "db_in_from_app" {
  security_group_id        = aws_security_group.db.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  cidr_blocks              = ["0.0.0.0/0"]
  source_security_group_id = aws_security_group.app.id
}
resource "aws_security_group_rule" "db_out_for_app" {
  security_group_id = aws_security_group.db.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 8000
  to_port           = 8000
  cidr_blocks       = ["0.0.0.0/0"]
}