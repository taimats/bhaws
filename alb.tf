# ----------------------
# ロードバランサー
# ----------------------
resource "aws_lb" "main" {
  name               = "${var.project}-${var.env}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.private_3a.id, aws_subnet.private_3c.id]
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

resource "aws_lb_target_group" "apps" {
  name     = "${var.project}-${var.env}-lb-target-group-apps"
  protocol = "HTTP"
  port     = 8080
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "app_3a" {
  target_group_arn = aws_lb_target_group.apps.arn
  target_id        = aws_instance.app_3a.id
}

resource "aws_lb_target_group_attachment" "app_3c" {
  target_group_arn = aws_lb_target_group.apps.arn
  target_id        = aws_instance.app_3c.id
}