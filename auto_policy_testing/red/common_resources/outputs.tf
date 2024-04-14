output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_subnet_1_id" {
  value = aws_subnet.subnet1.id
}

output "vpc_subnet_2_id" {
  value = aws_subnet.subnet2.id
}