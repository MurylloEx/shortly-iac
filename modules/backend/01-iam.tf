# Política do IAM referente ao CodeDeploy

data "aws_iam_policy_document" "codedeploy_policy_roles" {
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:Delete*",
      "s3:Put*",
      "s3:Abort*"
    ]
    resources = [aws_s3_bucket.codepipeline.arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["codedeploy:*"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole",
      "ec2:*"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "sns:Publish",
      "sns:Subscribe"
    ]
    resources = [
      aws_sns_topic.codedeploy_sns_topic.arn,
      "${aws_sns_topic.codedeploy_sns_topic.arn}:*"
    ]
  }
}

# Permite que EC2 e CodeDeploy assumam a role e executem ações no CodeDeploy
data "aws_iam_policy_document" "codedeploy_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "codedeploy.amazonaws.com",
        "ec2.amazonaws.com"
      ]
    }
  }
}

# Política IAM referente ao CodePipeline

data "aws_iam_policy_document" "codepipeline_policy_roles" {
  statement {
    effect    = "Allow"
    actions   = ["codedeploy:*"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["codebuild:*"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"
    actions = [
      "codestar-connections:GetConnection"
    ]
    resources = [aws_codestarconnections_connection.pipeline.arn]
  }
  depends_on = [aws_codestarconnections_connection.pipeline]
}

# Política do IAM referente ao EC2

data "aws_iam_policy_document" "ec2_policy_roles" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Política do IAM referente ao CodeBuild

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
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ssm:Get**",
      "ssm:List*",
      "ssm:Describe*"
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "s3:*"
    ]
  }

  statement {
    effect    = "Allow"
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
