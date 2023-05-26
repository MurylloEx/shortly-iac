data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  name               = "${var.app_stage}-${var.app_name}-codebuild"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

data "aws_iam_policy_document" "codebuild_pipeline" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*"
    ]
  }

  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "s3:*"
    ]
  }

  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "logs:Put*",
      "logs:Create*"
    ]
  }
}

resource "aws_iam_role_policy" "codebuild_pipeline" {
  role   = aws_iam_role.codebuild_role.name
  policy = data.aws_iam_policy_document.codebuild_pipeline.json
}

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
  }
}