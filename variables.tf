variable "ec2_ssh_key_name" {
  description = "Nome do par de chaves SSH criada no console da AWS"
  default     = "my-ssh-key"
}

variable "ec2_instance_type" {
  description = "Classe de instância EC2 a ser usada. Ex.: t3.micro, t2.small"
  default     = "t3.micro"
}

variable "github_user_name" {
  description = "Nome do usuário do GitHub"
  default     = "MurylloEx"
}

variable "github_branch_name" {
  description = "Nome da branch do repositório do projeto"
  default     = "master"
}

variable "github_repository_name" {
  description = "Nome do repositório do projeto"
  default     = "shortly-ec2"
}

variable "mysql_version" {
  description = "Versão do banco de dados MySQL, padrão: 8.0.27"
  default     = "8.0.27"
}

variable "mysql_instance_type" {
  description = "Classe da instância do banco de dados MySQL. Ex.: db.t3.micro, db.t2.small"
  default     = "db.t3.micro"
}

variable "mysql_allocated_storage" {
  description = "Tamanho a ser alocado em Gigabytes (Gibibytes) para a instância do banco de dados"
  default     = 5
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

variable "app_name" {
  description = "Nome da aplicação a ser implantada. Ex.: my-app"
  default     = "shortly"
}

variable "app_stage" {
  description = "Nome do estágio em que a aplicação se encontra. Ex.: dev, prod, stg"
  default     = "prod"
}

variable "app_service_name" {
  description = "Nome do daemon em execução dentro da instância EC2"
  default     = "shortly"
}

variable "app_service_description" {
  description = "Descrição da aplicação a ser usada no daemon em execução dentro da instância EC2"
  default     = "NestJS Shortly Service"
}

variable "app_service_base_path" {
  description = "Diretório base no qual a aplicação residirá dentro da instância EC2"
  default     = "/home/ubuntu/code-deploy"
}

variable "app_deployment_email_subscriber" {
  description = "E-mail que será notificado quando um deploy for bem-sucedido"
  default     = "muryllopimenta@gmail.com"
}
