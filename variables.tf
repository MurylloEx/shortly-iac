variable "aws_region" {
  type        = string
  description = "Região da AWS a ser usada. Ex.: us-east-1, us-east-2, us-west-1, us-west-2"
  default     = "us-east-1"
}

variable "aws_access_key" {
  type        = string
  description = "Valor da chave de acesso da AWS"
}

variable "aws_secret_access_key" {
  type        = string
  description = "Valor da chave de acesso secreta da AWS"
}

variable "ec2_ssh_key_name" {
  type        = string
  description = "Nome do par de chaves SSH criada no console da AWS"
}

variable "ec2_instance_type" {
  type        = string
  description = "Classe de instância EC2 a ser usada. Ex.: t3.micro, t2.small"
  default     = "t3.micro"
}

variable "github_user_name" {
  type        = string
  description = "Nome do usuário do GitHub"
}

variable "github_backend_branch_name" {
  type        = string
  description = "Nome da branch no repositório backend do projeto"
  default     = "master"
}

variable "github_backend_repository_name" {
  type        = string
  description = "Nome do repositório backend do projeto"
}

variable "github_frontend_branch_name" {
  type        = string
  description = "Nome da branch no repositório frontend do projeto"
  default     = "master"
}

variable "github_frontend_repository_name" {
  type        = string
  description = "Nome do repositório frontend do projeto"
}

variable "mysql_version" {
  type        = string
  description = "Versão do banco de dados MySQL, padrão: 8.0.27"
  default     = "8.0.27"
}

variable "mysql_instance_type" {
  type        = string
  description = "Classe da instância do banco de dados MySQL. Ex.: db.t3.micro, db.t2.small"
  default     = "db.t3.micro"
}

variable "mysql_allocated_storage" {
  type        = number
  description = "Tamanho a ser alocado em Gigabytes (Gibibytes) para a instância do banco de dados"
  default     = 5
}

variable "mysql_database_name" {
  type        = string
  description = "Nome do banco de dados MySQL"
  default     = "sample_database"
}

variable "mysql_username" {
  type        = string
  description = "Nome do usuário master do banco de dados MySQL"
  default     = "root"
}

variable "mysql_password" {
  type        = string
  description = "Senha do usuário master do banco de dados MySQL"
  default     = "s3cr3t$2023"
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

variable "app_service_name" {
  type        = string
  description = "Nome do daemon em execução dentro da instância EC2"
}

variable "app_service_description" {
  type        = string
  description = "Descrição da aplicação a ser usada no daemon em execução dentro da instância EC2"
}

variable "app_service_base_path" {
  type        = string
  description = "Diretório base no qual a aplicação residirá dentro da instância EC2"
  default     = "/home/ubuntu/code-deploy"
}

variable "app_deployment_email_subscriber" {
  type        = string
  description = "E-mail que será notificado quando um deploy for bem-sucedido"
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

variable "app_api_domain_name" {
  type        = string
  description = "Nome de domínio a ser utilizado nos registros que apontam para o API Gateway"
  default     = "api.example.com.br"
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

variable "app_back_dist_relative_path" {
  type        = string
  description = "Caminho da pasta que contém os artefatos gerados pelo build. Ex.: build, dist"
  default     = "dist"
}
