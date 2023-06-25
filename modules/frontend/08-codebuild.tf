# Definindo o projeto do CodeBuild para construir a aplicação React
resource "aws_codebuild_project" "codebuild_project" {
  name         = "${var.app_stage}-${var.app_name}-codebuild" # Substitua pelo nome do projeto desejado
  description  = "Builds the '${var.app_stage}-${var.app_name}' application"
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
            "npm install"
          ]
        }
        build = {
          commands = [
            "npm run build"
          ]
        }
        post_build = {
          commands = [
            "aws s3 sync ${var.app_front_dist_relative_path}/ s3://${aws_s3_bucket.site.bucket}",
            "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.s3_distribution.id} --paths \"/*\""
          ]
        }
      }
      artifacts = {
        files = [
          "${var.app_front_dist_relative_path}/**/*"
        ]
        name = "${aws_s3_bucket.site.bucket}"
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
      for_each = var.app_front_environment_variables
      content {
        type  = "PARAMETER_STORE"
        name  = environment_variable.key
        value = "/${var.app_name}/${var.app_stage}/${environment_variable.key}"
      }
    }
  }

  depends_on = [
    aws_s3_bucket.site,
    aws_iam_role.codebuild_role,
    aws_cloudfront_distribution.s3_distribution
  ]
}
