# This file will create a vpc and relevant subnets
# To be used in deploying the app and db
provider "aws" {
	region = var.region
}

# VPC Creation
resource "aws_vpc" "terraform_vpc" {
	cidr_block = var.vpc_ip
	instance_tenancy = "default"

	tags = {
		Name = "eng74-matt-terraform-vpc"
	}
}

# Internet Gateway 
resource "aws_internet_gateway" "terraform_igw" {
	vpc_id = aws_vpc.terraform_vpc.id

	tags = {
		Name = "eng74-matt-terraform-IGW"
	}
}

module "app" {
    source = "./modules/app_tier"
}

module "db" {
    source = "./modules/db_tier"
}