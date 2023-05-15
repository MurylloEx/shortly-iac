# Conexão com o GitHub (usando o CodeStar da AWS)
resource "aws_codestarconnections_connection" "pipeline" {
  name          = "${var.app_stage}-${var.app_name}-github"
  provider_type = "GitHub"
}
