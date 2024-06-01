output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "vpc_subnet_1_id" {
  value = aws_subnet.public1.id
}

output "vpc_subnet_2_id" {
  value = aws_subnet.public2.id
}

output "vpc_subnet_3_id" {
  value = aws_subnet.public3.id
}

output "vpc_subnet_private_1_id" {
  value = aws_subnet.private1.id
}

# output "kms_key_arn" {
#   value = aws_kms_key.this.arn
# }

output "sg_1_id" {
  value = aws_security_group.this.id
}

# output "wafregional_acl_id" {
#   value = aws_wafregional_web_acl.this.id
# }