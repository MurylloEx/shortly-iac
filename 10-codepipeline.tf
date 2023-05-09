# Política de acesso do CodeDeploy ao S3 e permissões para executar as ações do CodeDeploy
resource "aws_iam_policy" "codepipeline_policy" {
  name   = "${var.app_stage}-${var.app_name}-codepipeline-policy"
  policy = data.aws_iam_policy_document.codepipeline_policy_roles.json

  depends_on = [data.aws_iam_policy_document.codepipeline_policy_roles]
}

# Criação da role do IAM
resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.app_stage}-${var.app_name}-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json

  depends_on = [data.aws_iam_policy_document.codepipeline_assume_role]
}

# Associação da política à role do IAM
resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn

  depends_on = [
    aws_iam_role.codepipeline_role, 
    aws_iam_policy.codepipeline_policy
  ]
}

# Conexão com o GitHub (usando o CodeStar da AWS)
resource "aws_codestarconnections_connection" "pipeline" {
  name          = "${var.app_stage}-${var.app_name}-github-connection"
  provider_type = "GitHub"
}

# Criação da pipeline do CodePipeline
resource "aws_codepipeline" "pipeline" {
  name     = "${var.app_stage}-${var.app_name}-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.pipeline.arn
        FullRepositoryId = "${var.github_user_name}/${var.github_repository_name}"
        BranchName       = var.github_branch_name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ApplicationName     = aws_codedeploy_app.app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.group.deployment_group_name
      }
    }
  }

  depends_on = [
    aws_iam_role.codepipeline_role,
    aws_s3_bucket.codepipeline,
    aws_codestarconnections_connection.pipeline,
    aws_codedeploy_app.app,
    aws_codedeploy_deployment_group.group
  ]
}
