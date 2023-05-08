# Virtual Private Cloud

output "vpc_cidr_block" {
  value = aws_vpc.main_vpc.cidr_block
}

# Public VPC Subnet

output "vpc_public_subnet_arn" {
  value = aws_subnet.public_subnet.arn
}

output "vpc_public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "vpc_public_subnet_cidr_block" {
  value = aws_subnet.public_subnet.cidr_block
}

# Private VPC Subnet A

output "vpc_private_subnet_a_arn" {
  value = aws_subnet.private_subnet_a.arn
}

output "vpc_private_subnet_a_id" {
  value = aws_subnet.private_subnet_a.id
}

output "vpc_private_subnet_a_cidr_block" {
  value = aws_subnet.private_subnet_a.cidr_block
}

# Private VPC Subnet B

output "vpc_private_subnet_b_arn" {
  value = aws_subnet.private_subnet_b.arn
}

output "vpc_private_subnet_b_id" {
  value = aws_subnet.private_subnet_b.id
}

output "vpc_private_subnet_b_cidr_block" {
  value = aws_subnet.private_subnet_b.cidr_block
}

# Private VPC Subnet C

output "vpc_private_subnet_c_arn" {
  value = aws_subnet.private_subnet_c.arn
}

output "vpc_private_subnet_c_id" {
  value = aws_subnet.private_subnet_c.id
}

output "vpc_private_subnet_c_cidr_block" {
  value = aws_subnet.private_subnet_c.cidr_block
}

# MySQL Instances

output "mysql_arn" {
  value = aws_db_instance.mysql_instance.arn
}

output "mysql_engine" {
  value = aws_db_instance.mysql_instance.engine
}

output "mysql_engine_version" {
  value = aws_db_instance.mysql_instance.engine_version
}

output "mysql_database_name" {
  value = aws_db_instance.mysql_instance.db_name
}

output "mysql_address" {
  value = aws_db_instance.mysql_instance.address
}

output "mysql_port" {
  value = aws_db_instance.mysql_instance.port
}

output "mysql_subnet_name" {
  value = aws_db_instance.mysql_instance.db_subnet_group_name
}

# API Gateway

output "api_gateway_arn" {
  value = aws_apigatewayv2_api.api.arn
}

output "api_gateway_endpoint_url" {
  value = aws_apigatewayv2_api.api.api_endpoint
}

output "api_gateway_integration_url" {
  value = aws_apigatewayv2_integration.ec2_integration.integration_uri
}

# EC2 Instances

output "ec2_public_ip" {
  value = aws_eip.elastic_ip.public_ip
}

output "ec2_public_dns" {
  value = aws_eip.elastic_ip.public_dns
}

output "ec2_instance_state" {
  value = aws_instance.ec2.instance_state
}

# Simple Notification Service

output "sns_topic_arn" {
  value = aws_sns_topic.code_deploy_sns_topic.arn
}
