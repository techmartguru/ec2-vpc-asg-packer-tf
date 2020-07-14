provider "aws" {
  region = "us-east-1"
}

variable "instances_number" {
  default = "1"
}

variable "vpc" {
  default = "vpc-7a3f6600"
}

#### Ec2 eith EBS ###

module "ec2" {
  source = "../moule-ec2"

  instance_count = var.instances_number

  name                        = "docker-ec2"
  ami                         = "ami-0c1a0ce47291ff929"
  instance_type               = "t2.micro"
  subnet_ids                   = ["subnet-3ee7e962"]
  vpc_security_group_ids      = ["sg-061670c1bd7f3f494"]
  associate_public_ip_address = true
  key_name                    = "project-demo"
  user_data                   = "${file{"userdata.sh"}}"
}

resource "aws_volume_attachment" "ebs-attach" {
  count = var.instances_number

  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs[count.index].id
  instance_id = module.ec2.id[count.index]
}

resource "aws_ebs_volume" "ebs" {
  count = var.instances_number

  availability_zone = module.ec2.availability_zone[count.index]
  size              = 10
}

