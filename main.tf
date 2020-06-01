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

