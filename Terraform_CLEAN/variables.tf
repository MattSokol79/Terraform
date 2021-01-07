variable "region" {
	default = "eu-west-1" 
}

# VPC Related

variable "vpc_ip" {
	default = "179.23.0.0/16"
}

variable "pub_subnet_ip" {
	default = "179.23.1.0/24" 
}

variable "priv_subnet_ip" {
	default = "179.23.2.0/24" 
}

variable "avail_zone" {
	default = "eu-west-1b" 
}

variable "my_ip" {
	default = "84.69.118.155/32" 
}

variable "instance_type" {
    default = "t2.micro"
}

variable "ami_app" {
    default = "ami-0d645d116113782c5"
}

variable "ami_db" {
    default = "ami-026f0bb06657f628a"
}

variable "aws_key" {
    default = "eng74.matt.aws.key"
}