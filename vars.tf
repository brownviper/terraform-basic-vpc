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
