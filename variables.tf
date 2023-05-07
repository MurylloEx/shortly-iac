variable "ssh_key_name" {
  description = "Nome do par de chaves SSH criada no console da AWS"
  default     = "my-ssh-key"
}

variable "github_user_name" {
  description = "Nome do usuário do GitHub"
  default     = "MurylloEx"
}

variable "github_branch_name" {
  description = "Nome da branch do repositório do projeto"
  default     = "master"
}

variable "github_personal_token" {
  description = "Personal token do GitHub"
  default     = "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"
}

variable "github_repository_name" {
  description = "Nome do repositório do projeto"
  default     = "shortly-ec2"
}

variable "github_webhook_secret" {
  description = "Token secreto a ser usado no Webhook registrado no GitHub"
  default     = "6b695447b09098d54c50610b01b06224"
}

variable "codedeploy_success_email_recipient" {
  description = "E-mail que será notificado quando um deploy for bem-sucedido"
  default     = "muryllopimenta@gmail.com"
}

variable "codedeploy_deployment_path" {
  description = "value"
  default     = "/ubuntu/deploys/shortly"
}

variable "mysql_database_name" {
  description = "Nome do banco de dados MySQL"
  default     = "mydatabase"
}

variable "mysql_username" {
  description = "Nome do usuário master do banco de dados MySQL"
  default     = "root"
}

variable "mysql_password" {
  description = "Senha do usuário master do banco de dados MySQL"
  default     = "s3cr3t$2023"
}
