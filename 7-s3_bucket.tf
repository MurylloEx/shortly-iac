# Criação do bucket do S3
/* resource "aws_s3_bucket" "front" {
  bucket = "frontend-bucket"
} */

resource "aws_s3_bucket" "codepipeline" {
  bucket_prefix = "my-codepipeline-bucket"
}

