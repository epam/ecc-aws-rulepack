output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "vpc_subnet_1_id" {
  value = aws_subnet.subnet1.id
}

output "vpc_subnet_2_id" {
  value = aws_subnet.subnet2.id
}

output "vpc_subnet_3_id" {
  value = aws_subnet.subnet3.id
}

output "sg_1_id" {
  value = aws_security_group.this.id
}