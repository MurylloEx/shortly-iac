resource "aws_codebuild_project" "pipeline" {
  name         = "${var.app_stage}-${var.app_name}-codebuild"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type = "CODEPIPELINE"
    buildspec = yamlencode({
      version = 0.2
      phases = {
        install = {
          runtime-versions = {
            nodejs = 16
          }
          commands = [
            "npm install -g @nestjs/cli"
          ]
        }
        build = {
          commands = [
            "npm install",
            "npm run build"
          ]
        }
      }
      artifacts = {
        files = [
          "${var.app_back_dist_relative_path}/**/*"
        ]
        name = "${aws_s3_bucket.codepipeline.bucket}"
        exclude-paths = [
          "./node_modules/**/*",
          "./package-lock.json"
        ]
      }
    })
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type            = "LINUX_CONTAINER"
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    privileged_mode = true

    dynamic "environment_variable" {
      for_each = var.app_back_environment_variables
      content {
        type  = "PARAMETER_STORE"
        name  = environment_variable.key
        value = "/${var.app_name}/${var.app_stage}/${environment_variable.key}"
      }
    }
  }

  depends_on = [
    aws_iam_role.codebuild_role,
    aws_s3_bucket.codepipeline,
    aws_ssm_parameter.app_secrets
  ]
}
