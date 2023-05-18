# API Gateway

resource "aws_apigatewayv2_api" "api" {
  name          = "${var.app_stage}-${var.app_name}-apigateway"
  protocol_type = "HTTP"

  tags = {
    Name = "${var.app_stage}-${var.app_name}-apigateway"
  }
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true

  depends_on = [aws_apigatewayv2_api.api]
}

resource "aws_apigatewayv2_integration" "ec2_integration" {
  api_id = aws_apigatewayv2_api.api.id

  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = "http://${aws_eip.elastic_ip.public_dns}:8192/{proxy}"

  connection_type = "INTERNET"

  depends_on = [aws_apigatewayv2_api.api, aws_eip.elastic_ip]
}

resource "aws_apigatewayv2_route" "ec2_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.ec2_integration.id}"

  depends_on = [aws_apigatewayv2_integration.ec2_integration]
}

resource "aws_apigatewayv2_domain_name" "api_domain" {
  domain_name = var.app_api_domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.api_certificate.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [
    aws_acm_certificate.api_certificate, 
    aws_acm_certificate_validation.validation
  ]
}

resource "aws_apigatewayv2_api_mapping" "api_mapping" {
  api_id      = aws_apigatewayv2_api.api.id
  stage       = aws_apigatewayv2_stage.stage.id
  domain_name = aws_apigatewayv2_domain_name.api_domain.id

  depends_on = [
    aws_apigatewayv2_api.api,
    aws_apigatewayv2_stage.stage,
    aws_apigatewayv2_domain_name.api_domain
  ]
}
