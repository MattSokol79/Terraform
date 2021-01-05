# Terraform
**What is Terraform?**
![](img/Terraform.PNG)
- Designed to automate the deployment of servers and other infrastructure
- Similar to Ansible i.e. configuration management tool
- It is a Hashicorp product
- It is essentially a infrastructure provisioning tool (IAC orcheastration tool)

## Why Terraform?
- Allows you to describe your infrastructure as code and create execution plans:
  - These outline what will happen when code runs
  - Build graphs of resources
  - Automate changes.
- Helps you scale up and down as per the user demand 

## Use Cases
- Terraform allows you to automate infrastructure from multiple cloud providers simultaneously.
- Cloud independent - works with AWS-Azure-GCP and others

## Language used is HCL similar to json in terms of Syntax
- To start terraform in your directory -> `terraform init` (Creates a `.terraform` folder and a `terraform.lock.hcl` file)
- To check terraform files for errors -> `terraform plan` 
- Terraform reads access and secret keys automatically, so no need to specify them in the file 
- To run terraform/Launch instance -> `terraform apply` 
  - Security groups are DEFAULT i.e. port 80 from everywhere
- Now your instance should be up and running on AWS in under 40 secs!!