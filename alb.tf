# ----------------------
# ロードバランサー
# ----------------------
resource "aws_alb" "main" {
  name               = "${var.project}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app.id]
  subnets            = [aws_subnet.private_3a.id, aws_subnet.private_3c.id]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.main.id
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.apps.arn
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.main.id
  protocol          = "HTTPS"
  port              = 443
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.apps.arn
  }
}

resource "aws_alb_target_group" "apps" {
  name     = "${var.project}-${var.env}-alb-target-group-apps"
  protocol = "HTTP"
  port     = 8080
  vpc_id   = aws_vpc.main.id
}

resource "aws_alb_target_group_attachment" "app_3a" {
  target_group_arn = aws_alb_target_group.apps.arn
  target_id        = aws_instance.app_3a.id
}

resource "aws_alb_target_group_attachment" "app_3c" {
  target_group_arn = aws_alb_target_group.apps.arn
  target_id        = aws_instance.app_3c.id
}