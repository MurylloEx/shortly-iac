resource "aws_s3_bucket" "site" {
  bucket        = "${var.app_stage}-${var.app_name}-site"
  force_destroy = true

  tags = {
    Name        = "${var.app_name}"
    Environment = "${var.app_stage}"
  }
}

resource "aws_s3_bucket_ownership_controls" "site" {
  bucket = aws_s3_bucket.site.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  depends_on = [aws_s3_bucket.site]
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

  depends_on = [aws_s3_bucket.site]
}

resource "aws_s3_bucket_cors_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_origins = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE", "HEAD"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

data "aws_iam_policy_document" "allow_access" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.site.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }

  depends_on = [
    aws_s3_bucket.site,
    aws_cloudfront_distribution.s3_distribution
  ]
}

resource "aws_s3_bucket_public_access_block" "before_set_bucket_policy" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  lifecycle {
    ignore_changes = [
      block_public_acls,
      block_public_policy,
      ignore_public_acls,
      restrict_public_buckets
    ]
  }

  depends_on = [aws_s3_bucket.site]
}

resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.site.id
  policy = data.aws_iam_policy_document.allow_access.json

  depends_on = [aws_s3_bucket_public_access_block.before_set_bucket_policy]
}

resource "aws_s3_bucket_public_access_block" "after_set_bucket_policy" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket_policy.allow_access]
}
