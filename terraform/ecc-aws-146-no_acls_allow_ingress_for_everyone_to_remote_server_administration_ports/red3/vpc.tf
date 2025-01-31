resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "146_aws_vpc_red3"
  }
}

resource "aws_default_network_acl" "this" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id
  tags = {
    Name = "146_default_network_acl_red3"
  }
  ingress {
    protocol   = "udp"
    rule_no    = 2
    action     = "allow"
    ipv6_cidr_block = "::/0"
    from_port  = 3389
    to_port    = 3389
  }
  ingress {
    protocol   = "udp"
    rule_no    = 20
    action     = "deny"
    ipv6_cidr_block = "::/0"
    from_port  = 3389
    to_port    = 3389
  }
}
