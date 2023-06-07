terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.45"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    template = {
      source = "hashicorp/template"
      version = "~> 2.2"
    }

    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "~> 2.3"
    }
  }

  required_version = "~> 1.4"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_access_key
}

module "backend" {
  source                          = "./modules/backend"
  aws_region                      = var.aws_region
  ec2_ssh_key_name                = var.ec2_ssh_key_name
  ec2_instance_type               = var.ec2_instance_type
  github_user_name                = var.github_user_name
  github_branch_name              = var.github_backend_branch_name
  github_repository_name          = var.github_backend_repository_name
  mysql_version                   = var.mysql_version
  mysql_instance_type             = var.mysql_instance_type
  mysql_allocated_storage         = var.mysql_allocated_storage
  mysql_database_name             = var.mysql_database_name
  mysql_username                  = var.mysql_username
  mysql_password                  = var.mysql_password
  app_name                        = "${var.app_name}-back"
  app_stage                       = var.app_stage
  app_service_name                = var.app_service_name
  app_service_description         = var.app_service_description
  app_service_base_path           = var.app_service_base_path
  app_deployment_email_subscriber = var.app_deployment_email_subscriber
  app_back_dist_relative_path     = var.app_back_dist_relative_path
  app_route53_zone_name           = var.app_route53_zone_name
  app_api_domain_name             = var.app_api_domain_name
  app_back_environment_variables  = var.app_back_environment_variables
}

module "frontend" {
  source                          = "./modules/frontend"
  github_user_name                = var.github_user_name
  github_branch_name              = var.github_frontend_branch_name
  github_repository_name          = var.github_frontend_repository_name
  app_name                        = "${var.app_name}-front"
  app_stage                       = var.app_stage
  app_front_dist_relative_path    = var.app_front_dist_relative_path
  app_route53_zone_name           = var.app_route53_zone_name
  app_domain_name                 = var.app_domain_name
  app_www_domain_name_alias       = var.app_www_domain_name_alias
  app_has_www_domain_name_alias   = var.app_has_www_domain_name_alias
  app_front_environment_variables = var.app_front_environment_variables

  depends_on = [module.backend]
}
