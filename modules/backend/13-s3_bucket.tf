# Criação do bucket do S3
resource "aws_s3_bucket" "codepipeline" {
  bucket = "${var.app_stage}-${var.app_name}-codepipeline"
  force_destroy = true
}
