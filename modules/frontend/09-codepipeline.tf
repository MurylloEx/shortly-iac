resource "aws_codepipeline" "pipeline" {
  name     = "${var.app_stage}-${var.app_name}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.site.bucket
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
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "${var.github_user_name}/${var.github_repository_name}"
        BranchName       = "${var.github_branch_name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["src_out"]
      output_artifacts = ["build_out"]

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_project.name
      }
    }
  }

  depends_on = [
    aws_s3_bucket.site,
    aws_iam_role.codepipeline_role,
    aws_codebuild_project.codebuild_project,
    aws_codestarconnections_connection.github,
  ]
}
