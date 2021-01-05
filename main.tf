# Which cloud provider required 
# AWS as we have our AMIs on AWS

provider "aws" {
	
	region = var.region	
}

resource "aws_instance" "db_instance" {
	
	ami = var.ami_db
	instance_type = var.instance_type
	associate_public_ip_address = true
	tags = {
	    Name = "eng74-matt-db-terraform"
	}
	key_name = var.aws_key
} 

resource "aws_instance" "nodejs_instance" {
	
	ami = var.ami_app
	instance_type = var.instance_type
	associate_public_ip_address = true
	tags = {
	    Name = "eng74-matt-app-terraform-2"
	}
	key_name = var.aws_key
} 
