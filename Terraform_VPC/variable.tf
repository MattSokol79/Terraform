variable "region" {
	default = "eu-west-1" 
}

# VPC Related

variable "vpc_ip" {
	default = "174.23.0.0/16"
}

variable "pub_subnet_ip" {
	default = "174.23.1.0/24" 
}

variable "priv_subnet_ip" {
	default = "174.23.2.0/24" 
}

variable "avail_zone" {
	default = "eu-west-1b" 
}

variable "my_ip" {
	default = "84.69.118.155/32" 
}

