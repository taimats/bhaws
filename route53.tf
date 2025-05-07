# ----------------------
# Route53 ホストゾーン
# ----------------------
variable "domain" {
  type        = string
  description = "ドメイン名"
}

resource "aws_route53_zone" "main" {
  name          = var.domain
  force_destroy = false

  tags = {
    Name = "${var.project}-${var.env}-route53-zone-main"
  }
}

# ----------------------
# Route53 レコード
# ----------------------
# ALBレコード
resource "aws_route53_record" "alb" {
  zone_id = aws_route53_zone.main.id
  name    = "www.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_lb.main.name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}