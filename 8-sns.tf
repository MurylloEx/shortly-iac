# Criação do tópico do SNS
resource "aws_sns_topic" "code_deploy_sns_topic" {
  name = "code-deploy-sns-topic"
}

# Assinatura do tópico do SNS pelo grupo de implantação do CodeDeploy
resource "aws_sns_topic_subscription" "code_deploy_sns_topic_subscription" {
  topic_arn = aws_sns_topic.code_deploy_sns_topic.arn
  protocol  = "email"
  endpoint  = var.codedeploy_success_email_recipient
}
