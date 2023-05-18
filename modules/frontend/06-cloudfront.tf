resource "aws_cloudfront_origin_access_control" "site" {
  name                              = "${var.app_stage}-${var.app_name}-cloudfront-oac"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  origin_access_control_origin_type = "s3"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Content Delivery Network for ${var.app_stage}-${var.app_name} application"
  price_class         = "PriceClass_100"
  default_root_object = "index.html"
  aliases = !var.app_has_www_domain_name_alias ? [var.app_domain_name] : [
    var.app_domain_name,
    var.app_www_domain_name_alias
  ]

  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = "${var.app_stage}-${var.app_name}-site"
    origin_access_control_id = aws_cloudfront_origin_access_control.site.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.app_stage}-${var.app_name}-site"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    default_ttl            = 3600
    min_ttl                = 0
    max_ttl                = 86400

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

  custom_error_response {
    error_code         = 403
    response_code      = 404
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.certificate.arn
    ssl_support_method             = "sni-only"
  }

  depends_on = [
    aws_s3_bucket.site,
    aws_acm_certificate.certificate,
    aws_acm_certificate_validation.validation,
    aws_cloudfront_origin_access_control.site
  ]
}
