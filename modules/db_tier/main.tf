module "myip1" {
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

# Private Subnet
resource "aws_subnet" "terraform_private_subnet" {
	vpc_id = aws_vpc.terraform_vpc.id
	cidr_block = var.priv_subnet_ip
	availability_zone = var.avail_zone

	tags = {
		Name = "eng74-matt-terraform-priv-subnet"
	}
}

# Route table for the Private Subnet
resource "aws_route_table" "terraform_route_table_private" {
	vpc_id = aws_vpc.terraform_vpc.id
    
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
    }

	tags = {
		Name = "eng74-matt-terraform-priv-route"
	}
}

# Route table association PRIVATE
resource "aws_route_table_association" "terraform_rta_private"{
	subnet_id = aws_subnet.terraform_private_subnet.id
	route_table_id = aws_route_table.terraform_route_table_private.id
}

# Private Subnet NACL
resource "aws_network_acl" "terraform_priv_NACL" {
	vpc_id = aws_vpc.terraform_vpc.id
	subnet_ids = [aws_subnet.terraform_private_subnet.id]

	ingress {
		protocol = "tcp"
		rule_no = 100
		action = "allow"
		cidr_block = var.pub_subnet_ip
		from_port = "22"
		to_port = "22"
	}

	ingress {
		protocol = "tcp"
		rule_no = 110
		action = "allow"
		cidr_block = var.pub_subnet_ip
		from_port = "27017"
		to_port = "27017"
	}
    
    ingress {
		protocol = "tcp"
		rule_no = 120
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = "1024"
		to_port = "65535"
	}

	egress {
		protocol = "tcp"
		rule_no = 100
		action = "allow"
		cidr_block = var.pub_subnet_ip
		from_port = "1024"
		to_port = "65535"
	}

    egress {
		protocol = "tcp"
		rule_no = 110
		action = "allow"
		cidr_block = var.pub_subnet_ip
		from_port = "80"
		to_port = "80"
	}


	tags = {
		Name = "eng74-matt-terraform-priv-NACL"
	}
}


# Security Group for the DB EC2 Instance
resource "aws_security_group" "sg_db" {
  name = "eng74-matt-terraform-db3"
  vpc_id = aws_vpc.terraform_vpc.id
  description = "A security group for the DB instance"

  ingress {
    description = "For the MongoDB communication"
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

  ingress {
    description = "SSH from nodejs_app_instance"
    from_port = 22
    to_port = 22
    protocol = "tcp"
     # SSHing from the controller or my ip
    cidr_blocks = ["84.69.118.155/32"]
   }

  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "eng74-matt-terraform-sg-db"
  }
}

# VPC Security Group
resource "aws_security_group" "terraform_VPC_SG" {
	vpc_id = aws_vpc.terraform_vpc.id

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["${module.myip1.address}/32"]
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
