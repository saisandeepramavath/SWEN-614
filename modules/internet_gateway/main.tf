variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

resource "aws_internet_gateway" "wordpress_igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "WordPress Internet Gateway"
  }
}

output "igw_id" {
  value = aws_internet_gateway.wordpress_igw.id
}
