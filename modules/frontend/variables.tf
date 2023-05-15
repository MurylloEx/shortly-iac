variable "github_user_name" {
  type        = string
  description = "Nome do usuário do GitHub"
}

variable "github_branch_name" {
  type        = string
  description = "Nome da branch do repositório do projeto"
  default     = "master"
}

variable "github_repository_name" {
  type        = string
  description = "Nome do repositório do projeto"
}

variable "app_name" {
  type        = string
  description = "Nome da aplicação a ser implantada. Ex.: my-app"
}

variable "app_stage" {
  type        = string
  description = "Nome do estágio em que a aplicação se encontra. Ex.: dev, prod, stg"
  default     = "prod"
}

variable "app_route53_zone_name" {
  type        = string
  description = "Nome da zona hospedada no Route53. Ex.: example.com.br"
  default     = "example.com.br"
}

variable "app_domain_name" {
  type        = string
  description = "Nome de domínio a ser utilizado nos registros que apontam para o CloudFront"
  default     = "example.com.br"
}

variable "app_www_domain_name_alias" {
  type        = string
  description = "Alias www que apontará para o CloudFront. Ex.: www.example.com.br"
  default     = "www.example.com.br"
}

variable "app_has_www_domain_name_alias" {
  type        = bool
  description = "Especifica se o domínio em questão deverá possuir um alias DNS em www apontando para o CloudFront"
  default     = false
}

variable "app_front_dist_relative_path" {
  type        = string
  description = "Caminho da pasta que contém os artefatos gerados pelo build. Ex.: build, dist"
  default     = "dist"
}

