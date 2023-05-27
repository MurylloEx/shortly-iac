resource "aws_ssm_parameter" "app_secrets" {
  for_each    = var.app_back_environment_variables
  name        = "/${var.app_name}/${var.app_stage}/${each.key}"
  type        = "String"
  description = "Environment variable: '${var.app_stage}-${var.app_name}-${each.key}'"
  value       = each.value
}
