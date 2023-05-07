# Política de acesso do CodeDeploy ao S3 e permissões para executar as ações do CodeDeploy
resource "aws_iam_policy" "codedeploy_policy" {
  name   = "codedeploy-policy"
  policy = data.aws_iam_policy_document.codedeploy_policy_roles.json
}

# Criação da role do IAM
resource "aws_iam_role" "codedeploy_role" {
  name               = "my-codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json
}

# Associação da política à role do IAM
resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  policy_arn = aws_iam_policy.codedeploy_policy.arn
  role       = aws_iam_role.codedeploy_role.name
}

# Criação da aplicação do CodeDeploy
resource "aws_codedeploy_app" "app" {
  name = "my-codeploy-app"
}

# Criação do grupo de implantação do CodeDeploy
resource "aws_codedeploy_deployment_group" "group" {
  app_name               = aws_codedeploy_app.app.name
  service_role_arn       = aws_iam_role.codedeploy_role.arn
  deployment_group_name  = "my-deployment-group"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Name"
      value = "ec2-instance"
    }

    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Application"
      value = "shortly"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  trigger_configuration {
    trigger_events     = ["DeploymentStart", "DeploymentSuccess"]
    trigger_name       = "my-trigger"
    trigger_target_arn = aws_sns_topic.code_deploy_sns_topic.arn
  }

  load_balancer_info {
    target_group_info {
      name = "my-target-group"
    }
  }
}
