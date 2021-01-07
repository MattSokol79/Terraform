# This file contains all code for the Private Subnet and NACL

# Module to obtain my ip
module "myip" {
  source  = "4ops/myip/http"
  version = "1.0.0"
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
