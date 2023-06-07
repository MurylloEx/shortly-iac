# Instancias EC2

data "template_file" "ec2_daemon_service" {
  template = file("${path.module}/scripts/daemon.service")

  vars = {
    APP_STAGE               = var.app_stage
    APP_SERVICE_NAME        = var.app_service_name
    APP_SERVICE_DESCRIPTION = var.app_service_description
    APP_SERVICE_BASE_PATH   = var.app_service_base_path
  }
}

data "template_file" "ec2_ssm_parameters" {
  template = file("${path.module}/scripts/parameters.sh")

  vars = {
    AWS_REGION = var.aws_region
    APP_NAME   = var.app_name
    APP_STAGE  = var.app_stage
  }
}

data "template_file" "ec2_bootstrap_script" {
  template = file("${path.module}/scripts/bootstrap.sh")

  vars = {
    AWS_REGION       = var.aws_region
    APP_SERVICE_NAME = var.app_service_name
  }
}

data "cloudinit_config" "ec2_user_data" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = yamlencode({
      write_files = [
        {
          encoding    = "b64"
          content     = base64encode("${data.template_file.ec2_ssm_parameters.rendered}")
          path        = "/etc/profile.d/aws_ssm_parameters.sh"
          owner       = "root:root"
          permissions = "0755"
        },
        {
          encoding    = "b64"
          content     = base64encode("${data.template_file.ec2_daemon_service.rendered}")
          path        = "/etc/systemd/system/${var.app_service_name}.service"
          owner       = "root:root"
          permissions = "0755"
        },
        {
          encoding    = "b64"
          content     = base64encode("${data.template_file.ec2_bootstrap_script.rendered}")
          path        = "/tmp/${var.app_service_name}-bootstrap.sh"
          owner       = "root:root"
          permissions = "0755"
        }
      ]
      runcmd = ["./tmp/${var.app_service_name}-bootstrap.sh"]
    })
  }

  depends_on = [
    data.template_file.ec2_ssm_parameters,
    data.template_file.ec2_daemon_service,
    data.template_file.ec2_bootstrap_script
  ]
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_ssh_key_name

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = data.cloudinit_config.ec2_user_data.rendered

  tags = {
    Name        = "${var.app_stage}-${var.app_name}-ec2-instance"
    Application = "${var.app_stage}-${var.app_name}"
  }

  depends_on = [
    data.aws_ami.ubuntu,
    data.cloudinit_config.ec2_user_data,
    aws_subnet.public_subnet,
    aws_security_group.ec2_security_group
  ]
}
