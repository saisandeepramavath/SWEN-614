resource "aws_vpc" "wordpress_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "WordPress VPC"
  }
}

output "vpc_id" {
  value = aws_vpc.wordpress_vpc.id
}
