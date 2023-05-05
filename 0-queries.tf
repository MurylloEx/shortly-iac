# Data Queries

# Fetch all IPv4 CIDR blocks of API Gateway service in us-east-1 zone
data "aws_ip_ranges" "api_gateway" {
  regions  = ["us-east-1"]
  services = ["api_gateway"]
}

# Fetch the most recent Ubuntu 20.04 AMD64 AMI 
# with HVM virtualization type and SSD storage
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
