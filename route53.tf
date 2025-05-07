# ----------------------
# Route53で作成済みのドメインを使ってホストゾーンを生成
# ----------------------
variable "domain" {
  type        = string
  description = "ドメイン名"
}

variable "host_zone_id" {
  type        = string
  description = "ホストゾーンID"
}

data "aws_route53_zone" "main" {
  zone_id      = var.host_zone_id
  private_zone = false

  tags = {
    Name = "${var.project}-${var.env}-route53-zone-main"
  }
}

# ----------------------
# ロードバランサー用のDNSレコード
# ----------------------
resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.main.id
  name    = "www.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_lb.main.name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}