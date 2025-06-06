# ----------------------
# ロードバランサー
# ----------------------
resource "aws_lb" "main" {
  name               = "${var.project}-${var.env}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_01.id, aws_subnet.public_02.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apps.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  protocol          = "HTTPS"
  port              = 443
  certificate_arn   = aws_acm_certificate.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apps.arn
  }
}

variable "health_check_path" {
  type        = string
  description = "ロードバランサーがヘルスチェックで使用するパス"
}

variable "health_check_port" {
  type        = string
  description = "ロードバランサーがヘルスチェックで使用するポート番号"
}

resource "aws_lb_target_group" "apps" {
  name     = "${var.project}-${var.env}-lb-target-group-apps"
  protocol = "HTTP"
  port     = 8080
  vpc_id   = aws_vpc.main.id

  health_check {
    path     = var.health_check_path
    port     = var.health_check_port
    interval = 30
  }
}

resource "aws_lb_target_group_attachment" "app_01" {
  target_group_arn = aws_lb_target_group.apps.arn
  target_id        = aws_instance.app_01.id
}

resource "aws_lb_target_group_attachment" "app_02" {
  target_group_arn = aws_lb_target_group.apps.arn
  target_id        = aws_instance.app_02.id
}