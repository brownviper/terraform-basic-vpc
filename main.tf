variable "aws_region" {
  default = "eu-west-2"
}
variable "vpc_cidr" {
  default = "192.168.0.0/16"
}
variable "vpc_tenancy" {
  default = "default"
}
variable "vpc_enable_dns_support" {
  default = true
}
variable "vpc_enable_dns_hostnames" {
  default = true
}
variable "vpc_name" {
  default = "titus"
}
variable "public_cidr" {
  default = "192.168.1.0/24"
}
variable "ami_id" {
  default = "ami-0330ffc12d7224386"
}
variable "instance_type" {
  default = "t2.micro"
}

// specify the cloud tech provider i.e. aws. azure
provider "aws" {
  // profile = "profile_name_to_use" // specify profile name either here or in the env variable AWS_PROFILE
  region = var.aws_region
}

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = var.vpc_tenancy
  enable_dns_support = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.public_cidr

  tags = {
    Name = "${var.vpc_name}-net-public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name =  "${var.vpc_name}-IGW"
  }
}

resource "aws_route" "route-public" {
  route_table_id         = aws_vpc.main_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_vpc.main_vpc.main_route_table_id
}

resource "aws_security_group" "ec2-sg" {
  name        = "security-group"
  description = "allow inbound access to our public EC2"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public-ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [ aws_security_group.ec2-sg.id ]
  associate_public_ip_address = true

  tags = {
    Name = "ec2-main"
  }

  depends_on = [ aws_vpc.main_vpc, aws_internet_gateway.igw ]
}

output "ec2-public-ip" {
  value = aws_instance.public-ec2.public_ip
}
output "igw_id" {
  value = aws_internet_gateway.igw.id
}
output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
output "vpc_arn" {
  value = aws_vpc.main_vpc.arn
}
output "vpc_cidr" {
  value = aws_vpc.main_vpc.cidr_block
}
output "subnet_public_id" {
  value = aws_subnet.public.id
}

