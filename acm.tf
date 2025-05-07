# ----------------------
# SSL証明書
# ----------------------
resource "aws_acm_certificate" "main" {
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    data.aws_route53_zone.main
  ]

  tags = {
    Name = "${var.project}-${var.env}-acm-cert-main"
  }
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_record : record.fqdn]
}

# ----------------------
# 証明書のDNS検証用レコード
# ----------------------
resource "aws_route53_record" "cert_validation_record" {
  zone_id = data.aws_route53_zone.main.id
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.record]
}

