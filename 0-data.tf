# Data Queries

# Fetch all IPv4 CIDR blocks of API Gateway service in us-east-1 zone
data "aws_ip_ranges" "api_gateway" {
  regions  = ["us-east-1"]
  services = ["api_gateway"]
}

# Fetch the most recent Ubuntu 20.04 AMD64 AMI 
# with HVM virtualization type and SSD storage
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_iam_policy_document" "codedeploy_policy_roles" {
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:Put*"
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
      "sns:Publish",
      "sns:Subscribe"
    ]
    resources = [
      aws_sns_topic.code_deploy_sns_topic.arn,
      "${aws_sns_topic.code_deploy_sns_topic.arn}:*"
    ]
  }
}

# Permite que EC2 e CodeDeploy assumam a role e executem ações no CodeDeploy
data "aws_iam_policy_document" "codedeploy_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "codedeploy.amazonaws.com",
        "ec2.amazonaws.com"
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "codepipeline_policy_roles" {
  statement {
    effect    = "Allow"
    actions   = ["codedeploy:*"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = ["codestar-connections:UseConnection"]
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
    effect  = "Allow"
    actions = [
      "codestar-connections:GetConnection"
    ]
    resources = [
      aws_codestarconnections_connection.pipeline.arn
    ]
  }
}
