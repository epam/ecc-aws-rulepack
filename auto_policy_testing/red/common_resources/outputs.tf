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

output "vpc_subnet_private_1_id" {
  value = aws_subnet.private1.id
}

output "az_subnet_priv_1" {
  value = {
    az_name = data.aws_availability_zones.this.names[0]
    az_id = data.aws_availability_zones.this.zone_ids[0]
  }
}


output "sg_1_id" {
  value = aws_security_group.this.id
}

