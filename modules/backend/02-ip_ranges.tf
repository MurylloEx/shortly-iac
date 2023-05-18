# Fetch all IPv4 CIDR blocks of API Gateway service in the current zone
data "aws_ip_ranges" "api_gateway" {
  regions  = ["${var.aws_region}"]
  services = ["api_gateway"]
}
