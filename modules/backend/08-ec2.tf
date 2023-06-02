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

data "template_file" "ec2_bootstrap_script" {
  template = file("${path.module}/scripts/bootstrap.sh")

  vars = {
    AWS_REGION             = var.aws_region
    APP_SERVICE_NAME       = var.app_service_name
    DAEMON_SERVICE_CONTENT = data.template_file.ec2_daemon_service.rendered
  }

  depends_on = [data.template_file.ec2_daemon_service]
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_ssh_key_name

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = data.template_file.ec2_bootstrap_script.rendered

  tags = {
    Name        = "${var.app_stage}-${var.app_name}-ec2-instance"
    Application = "${var.app_stage}-${var.app_name}"
  }

  depends_on = [
    data.aws_ami.ubuntu,
    aws_subnet.public_subnet,
    aws_security_group.ec2_security_group
  ]
}
