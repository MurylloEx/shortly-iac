# Política de acesso do CodeDeploy ao S3 e permissões para executar as ações do CodeDeploy
resource "aws_iam_policy" "codedeploy_policy" {
  name   = "${var.app_stage}-${var.app_name}-codedeploy-policy"
  policy = data.aws_iam_policy_document.codedeploy_policy_roles.json

  depends_on = [data.aws_iam_policy_document.codedeploy_policy_roles]
}

# Criação da role do IAM
resource "aws_iam_role" "codedeploy_role" {
  name               = "${var.app_stage}-${var.app_name}-codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json

  depends_on = [data.aws_iam_policy_document.codedeploy_assume_role]
}

# Associação da política à role do IAM
resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = aws_iam_policy.codedeploy_policy.arn

  depends_on = [
    aws_iam_role.codedeploy_role,
    aws_iam_policy.codedeploy_policy
  ]
}

# Criação da aplicação do CodeDeploy
resource "aws_codedeploy_app" "codedeploy_app" {
  name = "${var.app_stage}-${var.app_name}-codeploy-app"
}

# Criação do grupo de implantação do CodeDeploy
resource "aws_codedeploy_deployment_group" "codedeploy_group" {
  app_name               = aws_codedeploy_app.codedeploy_app.name
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

  depends_on = [
    aws_codedeploy_app.codedeploy_app,
    aws_iam_role.codedeploy_role,
  ]
}

resource "local_file" "codedeploy_appspec" {
  filename = "${path.root}/build/appspec.json"
  content = jsonencode({
    version = "0.0"
    os      = "linux"
    files = [
      {
        source      = "."
        destination = "${var.app_service_base_path}/${var.app_stage}-${var.app_name}"
      }
    ]
    file_exists_behavior = "OVERWRITE"
    permissions = [
      {
        object  = "${var.app_service_base_path}/${var.app_stage}-${var.app_name}/scripts/aws"
        pattern = "**"
        mode    = 755
        type    = ["file"]
      },
      {
        object  = "${var.app_service_base_path}/${var.app_stage}-${var.app_name}/scripts/server"
        pattern = "**"
        mode    = 755
        type    = ["file"]
      }
    ]
    hooks = {
      ApplicationStop = [
        {
          location = "scripts/aws/application_stop.sh --cwd=${var.app_service_base_path}/${var.app_stage}-${var.app_name}"
          runas    = "root"
          timeout  = 300
        }
      ]
      BeforeInstall = [
        {
          location = "scripts/aws/before_install.sh --cwd=${var.app_service_base_path}/${var.app_stage}-${var.app_name}"
          runas    = "root"
          timeout  = 600
        }
      ]
      AfterInstall = [
        {
          location = "scripts/aws/after_install.sh --cwd=${var.app_service_base_path}/${var.app_stage}-${var.app_name}"
          runas    = "root"
          timeout  = 300
        }
      ]
      ApplicationStart = [
        {
          location = "scripts/aws/application_start.sh --cwd=${var.app_service_base_path}/${var.app_stage}-${var.app_name}"
          runas    = "root"
          timeout  = 300
        }
      ]
    }
  })
}

