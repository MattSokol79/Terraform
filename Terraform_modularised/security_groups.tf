# VPC Security Group
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
