resource "aws_security_group" "sg_db" {
  name = "eng74-matt-terraform-db"
  description = "A security group for the DB instance"

   ingress {
     description = "For the MongoDB communication"
     from_port = 27017
     to_port = 27017
     protocol = "tcp"
     # Terraform App instance private ip
     cidr_blocks = ["172.31.31.156/32"]
   }

  ingress {
    description = "SSH from nodejs_app_instance"
    from_port = 22
    to_port = 22
    protocol = "tcp"
     # SSHing from the controller or my ip
     cidr_blocks = ["172.31.35.2/32"]
   }

   egress {
     from_port = 0
     to_port = 0
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_app" {
  name = "eng74-matt-terraform-app"
  description = "A security group for the app instance"

  ingress {
    description = "HTTP for updates"
    from_port = 80
    to_port = 80
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
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }
}