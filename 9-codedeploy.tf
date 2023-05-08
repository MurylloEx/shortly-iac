# Política de acesso do CodeDeploy ao S3 e permissões para executar as ações do CodeDeploy
resource "aws_iam_policy" "codedeploy_policy" {
  name   = "${var.app_stage}-${var.app_name}-codedeploy-policy"
  policy = data.aws_iam_policy_document.codedeploy_policy_roles.json
}

# Criação da role do IAM
resource "aws_iam_role" "codedeploy_role" {
  name               = "${var.app_stage}-${var.app_name}-codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json
}

# Associação da política à role do IAM
resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  policy_arn = aws_iam_policy.codedeploy_policy.arn
  role       = aws_iam_role.codedeploy_role.name
}

# Criação da aplicação do CodeDeploy
resource "aws_codedeploy_app" "app" {
  name = "${var.app_stage}-${var.app_name}-codeploy-app"
}

# Criação do grupo de implantação do CodeDeploy
resource "aws_codedeploy_deployment_group" "group" {
  app_name               = aws_codedeploy_app.app.name
  service_role_arn       = aws_iam_role.codedeploy_role.arn
  deployment_group_name  = "${var.app_stage}-${var.app_name}-deployment-group"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Name"
      value = "${var.app_stage}-${var.app_name}-ec2-instance"
    }

    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Application"
      value = "${var.app_stage}-${var.app_name}"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  trigger_configuration {
    trigger_events     = ["DeploymentStart", "DeploymentSuccess"]
    trigger_name       = "${var.app_stage}-${var.app_name}-trigger"
    trigger_target_arn = aws_sns_topic.code_deploy_sns_topic.arn
  }

  load_balancer_info {
    target_group_info {
      name = "${var.app_stage}-${var.app_name}-target-group"
    }
  }
}
