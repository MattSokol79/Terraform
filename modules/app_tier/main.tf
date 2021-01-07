module "myip" {
  source  = "4ops/myip/http"
  version = "1.0.0"
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

# Public Subnet
resource "aws_subnet" "terraform_public_subnet" {
	vpc_id = aws_vpc.terraform_vpc.id
	cidr_block = var.pub_subnet_ip
	map_public_ip_on_launch = "true"  # Makes this a public subnet
	availability_zone = var.avail_zone

	tags = {
		Name = "eng74-matt-terraform-pub-subnet"
	}
}

# Route table for the Public Subnet
resource "aws_route_table" "terraform_route_table_public" {
	vpc_id = aws_vpc.terraform_vpc.id

	route {
		# Subnet can go everywhere
		cidr_block = "0.0.0.0/0"

		# Route table uses the IGW to reach the internet
		gateway_id = aws_internet_gateway.terraform_igw.id
	}

	tags = {
		Name = "eng74-matt-terraform-pub-route"
	}	
}

# Associating Route Table PUBLIC
resource "aws_route_table_association" "terraform_rta_public" {
	subnet_id = aws_subnet.terraform_public_subnet.id
	route_table_id = aws_route_table.terraform_route_table_public.id
}

# NACL for the Public Subnet
resource "aws_network_acl" "terraform_pub_NACL" {
	vpc_id = aws_vpc.terraform_vpc.id
	subnet_ids = [aws_subnet.terraform_public_subnet.id]

    ingress {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = "80"
        to_port = "80"
    }
    
    ingress {
        protocol = "tcp"
        rule_no = 110
        action = "allow"
        cidr_block = "${module.myip.address}/32"
        from_port = "22"
        to_port = "22"
    }

    ingress {
		protocol = "tcp"
		rule_no = 120
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = "443"
		to_port = "443"
	}

	ingress {
		protocol = "tcp"
		rule_no = 130
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = "1024"
		to_port = "65535"
	}

    egress {
		protocol = "-1"
		rule_no = 100
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 0
		to_port = 0
	}

	tags = {
		Name = "eng74-matt-terraform-pub-NACL"
	}
}

resource "aws_security_group" "terraform_VPC_SG" {
	vpc_id = aws_vpc.terraform_vpc.id

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["${module.myip.address}/32"]
	}

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	
	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

    egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "eng74-matt-terraform-VPC-SG"
	}
}


# Security Group for the App instance
resource "aws_security_group" "sg_app" {
  name = "eng74-matt-terraform-app3"
  vpc_id = aws_vpc.terraform_vpc.id
  description = "A security group for the app instance"

  ingress {
    description = "HTTP for updates"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from nodejs_app_instance"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # SSHing from my ip
    cidr_blocks = ["84.69.118.155/32"]
  }

  ingress {
    description = "Database receieve"
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS for updates"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Port 3000"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "eng74-matt-terraform-sg-app"
  }
}
