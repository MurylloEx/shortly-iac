# Elastic IP (future use for failover control)

resource "aws_eip" "elastic_ip" {
  vpc                       = true
  instance                  = aws_instance.ec2.id
  associate_with_private_ip = aws_instance.ec2.private_ip

  depends_on = [aws_instance.ec2]
}

resource "aws_eip_association" "elastic_ip_assoc" {
  instance_id   = aws_instance.ec2.id   # ID da instância EC2
  allocation_id = aws_eip.elastic_ip.id # ID do Elastic IP

  depends_on = [aws_instance.ec2, aws_eip.elastic_ip]
}
