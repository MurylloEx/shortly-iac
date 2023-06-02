# Fetch the most recent Ubuntu 18.04 AMD64 AMI 
# with HVM virtualization type and SSD storage
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    # Explain why use AMD64 instead of ARM
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
