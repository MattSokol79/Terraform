# This file will create the instances
# To be used in deploying the app and db

provider "aws" {
  region = var.region
}

# Creating the DB EC2 Instance
resource "aws_instance" "db_instance" {
	
	ami = var.ami_db
	instance_type = var.instance_type
	security_groups = [aws_security_group.sg_db.id]
    vpc_security_group_ids = [aws_security_group.terraform_VPC_SG.id]
	subnet_id = aws_subnet.terraform_private_subnet.id
	tags = {
	    Name = "eng74-matt-db-terraform"
	}
	key_name = var.aws_key
} 

# Creating the App EC2 Instance in the VPC
resource "aws_instance" "app_instance" {
	
	ami = var.ami_app
	instance_type = var.instance_type
	associate_public_ip_address = true
	security_groups = [aws_security_group.sg_app.id]
	vpc_security_group_ids = [aws_security_group.terraform_VPC_SG.id]
	subnet_id = aws_subnet.terraform_public_subnet.id
    tags = {
	    Name = "eng74-matt-app-terraform"
	}
	key_name = var.aws_key
	depends_on = [ 
		aws_instance.db_instance,
	]
    user_data = <<-EOF
        #! /bin/bash
        cd /home/ubuntu/app
        DB_HOST=${aws_instance.db_instance.private_ip} pm2 start app.js
        npm run seed
        EOF
} 

# Showing the App and DB instance IPs 
output "app_ip" {
  value = [aws_instance.app_instance.*.public_ip, aws_instance.app_instance.*.private_ip]
}

output "db_ip" {
  value = [aws_instance.db_instance.*.public_ip, aws_instance.db_instance.*.private_ip]
}

