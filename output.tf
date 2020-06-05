
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
