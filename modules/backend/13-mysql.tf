# MySQL DB

resource "aws_db_subnet_group" "mysql_subnet" {
  name = "${var.app_stage}-${var.app_name}-mysql-private"
  subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id,
    aws_subnet.private_subnet_c.id
  ]

  tags = {
    Name = "${var.app_stage}-${var.app_name} MySQL subnet group"
  }

  depends_on = [
    aws_subnet.private_subnet_a,
    aws_subnet.private_subnet_b,
    aws_subnet.private_subnet_c
  ]
}

resource "aws_db_instance" "mysql_instance" {
  identifier        = "${var.app_stage}-${var.app_name}-mysql"
  engine            = "mysql"
  engine_version    = var.mysql_version
  db_name           = var.mysql_database_name
  storage_type      = "gp2"
  instance_class    = var.mysql_instance_type
  allocated_storage = var.mysql_allocated_storage

  username = var.mysql_username
  password = var.mysql_password

  skip_final_snapshot = true  # Desativa a criação do snapshot do banco na exclusão do mesmo
  publicly_accessible = false # Defina como false se desejar que a instância seja privada
  multi_az            = false # Banco de dados não é multirregional

  vpc_security_group_ids = [aws_security_group.mysql_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.mysql_subnet.name

  availability_zone = "${var.aws_region}a"

  depends_on = [
    aws_security_group.mysql_security_group,
    aws_db_subnet_group.mysql_subnet
  ]
}
