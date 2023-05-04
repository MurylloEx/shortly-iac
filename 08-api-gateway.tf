resource "aws_apigatewayv2_api" "api_gateway_ec2_instance" {
  name          = "api-gw-example-1"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id = aws_apigatewayv2_api.api_gateway_ec2_instance.id

  name        = "prod"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "api_gateway_ec2_instance" {
  api_id = aws_apigatewayv2_api.api_gateway_ec2_instance.id

  integration_type   = "HTTP_PROXY"
  integration_uri    = "http://${aws_instance.ec2_instance.public_ip}/{proxy}"
  integration_method = "ANY"
  connection_type    = "INTERNET"
}

resource "aws_apigatewayv2_route" "api_gateway_ec2_instance" {
  api_id = aws_apigatewayv2_api.api_gateway_ec2_instance.id

  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.api_gateway_ec2_instance.id}"
}

output "api_gw_example_1_health_url" {
  value = "${aws_apigatewayv2_stage.prod.invoke_url}/health"
}
