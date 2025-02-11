# Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
}

# Subnets Module
module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_id
}

# Internet Gateway Module
module "internet_gateway" {
  source = "./modules/internet_gateway"
  vpc_id = module.vpc.vpc_id
}

# Route Table Module
module "route_table" {
  source = "./modules/route_table"
  vpc_id = module.vpc.vpc_id
  igw_id = module.internet_gateway.igw_id
  public_subnet_id = module.subnets.public_subnet_id
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

# EC2 Instance Module
module "ec2_instance" {
  source = "./modules/ec2_instance"
  subnet_id = module.subnets.public_subnet_id
  security_group_id = module.security_groups.ec2_sg_id
  key_name = var.key_name
  db_username = var.db_username
  db_password = var.db_password
  rds_endpoint = module.rds_instance.rds_endpoint
}

# RDS Instance Module
module "rds_instance" {
  source = "./modules/rds_instance"
  subnet_ids = [module.subnets.private_subnet_id, module.subnets.public_subnet_id]
  security_group_id = module.security_groups.rds_sg_id
  db_username = var.db_username
  db_password = var.db_password
}

# Outputs
output "ec2_public_ip" {
  value = module.ec2_instance.ec2_public_ip
}

output "rds_endpoint" {
  value = module.rds_instance.rds_endpoint
}