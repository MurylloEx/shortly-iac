# Criação do tópico do SNS
resource "aws_sns_topic" "codedeploy_sns_topic" {
  name = "${var.app_stage}-${var.app_name}-codedeploy-sns-topic"
}

# Assinatura do tópico do SNS pelo grupo de implantação do CodeDeploy
resource "aws_sns_topic_subscription" "code_deploy_sns_topic_subscription" {
  topic_arn = aws_sns_topic.codedeploy_sns_topic.arn
  protocol  = "email"
  endpoint  = var.app_deployment_email_subscriber

  depends_on = [aws_sns_topic.codedeploy_sns_topic]
}
