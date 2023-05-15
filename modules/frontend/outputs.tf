output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "s3_bucket_id" {
  value = aws_s3_bucket.site.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.site.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.site.arn
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.certificate.arn
}

output "acm_certificate_key_algorithm" {
  value = aws_acm_certificate.certificate.key_algorithm
}

output "acm_certificate_not_after" {
  value = aws_acm_certificate.certificate.not_after
}

output "acm_certificate_not_before" {
  value = aws_acm_certificate.certificate.not_before
}

output "acm_certificate_status" {
  value = aws_acm_certificate.certificate.status
}

output "codestar_connection_arn" {
  value = aws_codestarconnections_connection.github.arn
}

output "codestar_connection_id" {
  value = aws_codestarconnections_connection.github.id
}

output "codestar_connection_name" {
  value = aws_codestarconnections_connection.github.name
}

output "codepipeline_arn" {
  value = aws_codepipeline.pipeline.arn
}

output "codepipeline_id" {
  value = aws_codepipeline.pipeline.id
}

output "codepipeline_name" {
  value = aws_codepipeline.pipeline.name
}

output "codebuild_project_arn" {
  value = aws_codebuild_project.codebuild_project.arn
}

output "codebuild_project_id" {
  value = aws_codebuild_project.codebuild_project.id
}

output "codebuild_project_name" {
  value = aws_codebuild_project.codebuild_project.name
}
