# API Gateway

resource "aws_apigatewayv2_api" "api" {
  name          = "my-api"
  protocol_type = "HTTP"

  tags = {
    Name = "api-gateway"
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
