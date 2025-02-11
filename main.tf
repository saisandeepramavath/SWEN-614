# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # Set AWS region to US East 1 (N. Virginia)
}

# Local variables block for configuration values
locals {
    aws_key = "cloudshell"   # SSH key pair name for EC2 instance access
}

# Fetch the default VPC ID
data "aws_vpc" "default" {
  default = true
}

# Security group to allow HTTP traffic
resource "aws_security_group" "http_sg" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = data.aws_vpc.default.id  # Use the dynamically fetched VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance resource definition
resource "aws_instance" "my_server" {
   ami           = data.aws_ami.amazonlinux.id  # Use the AMI ID from the data source
   instance_type = var.instance_type            # Use the instance type from variables
   key_name      = "${local.aws_key}"          # Specify the SSH key pair name
   security_groups = [aws_security_group.http_sg.name]  # Attach the security group
   user_data =file("${path.module}/wp_install.sh")

  
   # Add tags to the EC2 instance for identification
   tags = {
     Name = "my ec2"
   }                  
}

output "public_ip"{
value = aws_instance.my_server.public_ip
}
