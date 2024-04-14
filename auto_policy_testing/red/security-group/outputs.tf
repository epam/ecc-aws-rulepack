output "security-group" {
  value = {
    security-group                                                     = aws_security_group.this1.id
    ecc-aws-027-prevent_0-65535_ingress_and_all                        = aws_security_group.this2.id
    ecc-aws-064-default_security_group_every_vpc_restricts_all_traffic = aws_default_security_group.this.id
    ecc-aws-386-security_group_without_tag_information                 = aws_security_group.this3.id
  }
}
