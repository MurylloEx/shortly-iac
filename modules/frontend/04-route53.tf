data "aws_route53_zone" "dns" {
  name = var.app_route53_zone_name
}

resource "aws_route53_record" "acm_records" {
  for_each = {
    for options in aws_acm_certificate.certificate.domain_validation_options : options.domain_name => {
      name   = options.resource_record_name
      record = options.resource_record_value
      type   = options.resource_record_type
    }
  }

  zone_id         = data.aws_route53_zone.dns.zone_id
  ttl             = 60
  allow_overwrite = true
  type            = each.value.type
  name            = each.value.name
  records         = [each.value.record]
}

resource "aws_route53_record" "www_record_cname" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = var.app_www_domain_name_alias
  type    = "CNAME"
  ttl     = 60

  count = var.app_has_www_domain_name_alias ? 1 : 0

  records = [aws_cloudfront_distribution.s3_distribution.domain_name]
}

resource "aws_route53_record" "root_record_a" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = var.app_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [
    data.aws_route53_zone.dns,
    aws_cloudfront_distribution.s3_distribution
  ]
}

resource "aws_route53_record" "root_record_aaaa" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = var.app_domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [
    data.aws_route53_zone.dns,
    aws_cloudfront_distribution.s3_distribution
  ]
}
