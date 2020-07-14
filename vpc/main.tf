provider "aws" {
  region = "us-east-1"
   version = "~> 2.20"
}

module "vpc" {
  #source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=master"
   source = "../modules" 
   name = "VPC-1"

  cidr = "10.16.0.0/16"

  azs                 = ["us-east-1a", "us-east-1b"]
  private_subnets     = ["10.16.1.0/24", "10.16.2.0/24"]


  create_database_subnet_group = false

  enable_nat_gateway = false
  single_nat_gateway = false

  enable_vpn_gateway = true

 # enable_s3_endpoint       = true
 # enable_dynamodb_endpoint = true

  enable_dhcp_options              = false
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.16.0.2"]

  tags = {
    Owner       = "Sandeep"
    Environment = "Dev"
    Name        = "vpc"
  }
}

