# This file contains all code for the Public Subnet and NACL

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
