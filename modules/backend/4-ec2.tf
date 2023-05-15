# Instancias EC2

resource "aws_security_group" "ec2_security_group" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    description = "Allow connections from public AWS API Gateway"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = data.aws_ip_ranges.api_gateway.cidr_blocks
  }

  ingress {
    description = "Allow ICMP packets from public Internet"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH connections from public Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outgoing connections to public Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [
    aws_vpc.main_vpc,
    data.aws_ip_ranges.api_gateway
  ]
}

# Política de acesso do EC2 ao S3
resource "aws_iam_policy" "ec2_policy" {
  name   = "${var.app_stage}-${var.app_name}-ec2-policy"
  policy = data.aws_iam_policy_document.ec2_policy_roles.json
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.app_stage}-${var.app_name}-ec2-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Associação da política à role do IAM
resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  policy_arn = aws_iam_policy.ec2_policy.arn
  role       = aws_iam_role.ec2_role.name
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.app_stage}-${var.app_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_ssh_key_name

  subnet_id            = aws_subnet.public_subnet.id
  security_groups      = [aws_security_group.ec2_security_group.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = templatefile("${path.module}/scripts/bootstrap.sh", {
    AWS_REGION              = var.aws_region
    APP_NAME                = var.app_name
    APP_STAGE               = var.app_stage
    APP_SERVICE_DESCRIPTION = var.app_service_description
    APP_SERVICE_NAME        = var.app_service_name
    APP_SERVICE_BASE_PATH   = var.app_service_base_path
  })

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
