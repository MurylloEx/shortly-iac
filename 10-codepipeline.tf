# Política de acesso do CodeDeploy ao S3 e permissões para executar as ações do CodeDeploy
resource "aws_iam_policy" "codepipeline_policy" {
  name   = "codepipeline-policy"
  policy = data.aws_iam_policy_document.codepipeline_policy_roles.json
}

# Criação da role do IAM
resource "aws_iam_role" "codepipeline_role" {
  name               = "my-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}

# Associação da política à role do IAM
resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

# Conexão com o GitHub (usando o CodeStar da AWS)
resource "aws_codestarconnections_connection" "pipeline" {
  name          = "my-github-connection"
  provider_type = "GitHub"
}

# Criação da pipeline do CodePipeline
resource "aws_codepipeline" "pipeline" {
  name     = "my-codepipeline"
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
        /* RoleArn                       = aws_iam_role.codedeploy_role.arn
        S3Bucket                      = aws_s3_bucket.codepipeline.id
        S3Key                         = "master.zip"
        IgnoreApplicationStopFailures = true */
      }
    }
  }
}
