# Política de acesso do CodeDeploy ao S3 e permissões para executar as ações do CodeDeploy
resource "aws_iam_policy" "codepipeline_policy" {
  name   = "${var.app_stage}-${var.app_name}-pipeline-policy"
  policy = data.aws_iam_policy_document.codepipeline_policy_roles.json

  depends_on = [data.aws_iam_policy_document.codepipeline_policy_roles]
}

# Criação da role do IAM
resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.app_stage}-${var.app_name}-pipeline-role"
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

# Criação da pipeline do CodePipeline
resource "aws_codepipeline" "pipeline" {
  name     = "${var.app_stage}-${var.app_name}-pipeline"
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
      output_artifacts = ["src_out"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.pipeline.arn
        FullRepositoryId = "${var.github_user_name}/${var.github_repository_name}"
        BranchName       = var.github_branch_name
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["src_out"]
      output_artifacts = ["build_out"]

      configuration = {
        ProjectName = aws_codebuild_project.pipeline.name
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
      input_artifacts = ["build_out"]

      configuration = {
        ApplicationName     = aws_codedeploy_app.codedeploy_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.codedeploy_group.deployment_group_name
      }
    }
  }

  depends_on = [
    aws_iam_role.codepipeline_role,
    aws_s3_bucket.codepipeline,
    aws_codestarconnections_connection.pipeline,
    aws_codedeploy_app.codedeploy_app,
    aws_codedeploy_deployment_group.codedeploy_group
  ]
}
