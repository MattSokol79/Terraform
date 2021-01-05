# Which cloud provider required 
# AWS as we have our AMIs on AWS

provider "aws" {
	
	region = var.region	
}

resource "aws_instance" "db_instance" {
	
	ami = var.ami_db
	instance_type = var.instance_type
	associate_public_ip_address = true
	security_groups = ["eng74-matt-terraform-db"]
	tags = {
	    Name = "eng74-matt-db-terraform-3"
	}
	key_name = var.aws_key
} 

resource "aws_instance" "app_instance" {
	
	ami = var.ami_app
	instance_type = var.instance_type
	associate_public_ip_address = true
	security_groups = ["eng74-matt-terraform-app"]
	vpc_security_group_ids = ["sg-0f89f296c11933e34"]
	tags = {
	    Name = "eng74-matt-app-terraform-3"
	}
	key_name = var.aws_key
} 

output "ip" {
  value = [aws_instance.app_instance.*.public_ip, aws_instance.app_instance.*.private_ip]
}
