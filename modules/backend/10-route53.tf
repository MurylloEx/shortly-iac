data "aws_route53_zone" "dns" {
  name = var.app_route53_zone_name
}

resource "aws_route53_record" "acm_records" {
  for_each = {
    for options in aws_acm_certificate.api_certificate.domain_validation_options : options.domain_name => {
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

  depends_on = [aws_acm_certificate.api_certificate]
}

resource "aws_route53_record" "api_record_a" {
  name    = aws_apigatewayv2_domain_name.api_domain.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.dns.id

  alias {
    name                   = aws_apigatewayv2_domain_name.api_domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.api_domain.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_apigatewayv2_domain_name.api_domain]
}

resource "aws_route53_record" "api_record_aaaa" {
  name    = aws_apigatewayv2_domain_name.api_domain.domain_name
  type    = "AAAA"
  zone_id = data.aws_route53_zone.dns.id

  alias {
    name                   = aws_apigatewayv2_domain_name.api_domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.api_domain.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_apigatewayv2_domain_name.api_domain]
}
