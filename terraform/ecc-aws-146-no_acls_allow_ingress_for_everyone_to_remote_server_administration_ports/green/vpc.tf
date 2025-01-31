resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "146_aws_vpc_green1"
  }
}

resource "aws_default_network_acl" "this" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id
  tags = {
    Name = "146_default_network_acl_green1"
  }
  ingress {
    protocol   = "udp"
    rule_no    = 1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 123
    to_port    = 300 
  }  
  ingress {
    protocol   = "udp"
    rule_no    = 2
    action     = "allow"
    cidr_block = "10.0.0.0/24"
    from_port  = 22
    to_port    = 22 
  } 
  ingress {
    protocol   = "tcp"
    rule_no    = 3
    action     = "allow"
    ipv6_cidr_block = "FE80::/10"
    from_port  = 22
    to_port    = 22 
  } 
  ingress {
    protocol   = "udp"
    rule_no    = 4
    action     = "allow"
    cidr_block = "10.0.0.0/24"
    from_port  = 1
    to_port    = 65535 
  } 
  ingress {
    protocol   = "47"
    rule_no    = 5
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1
    to_port    = 65535 
  } 
  ingress {
    protocol   = "47"
    rule_no    = 6
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 53
    to_port    = 53 
  } 
}
