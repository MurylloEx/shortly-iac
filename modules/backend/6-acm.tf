resource "aws_acm_certificate" "api_certificate" {
  domain_name               = data.aws_route53_zone.dns.name
  subject_alternative_names = ["*.${data.aws_route53_zone.dns.name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [data.aws_route53_zone.dns]
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.api_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_records : record.fqdn]

  depends_on = [
    aws_acm_certificate.api_certificate,
    aws_route53_record.acm_records
  ]
}

