resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "146_aws_vpc_red1"
  }
}

resource "aws_default_network_acl" "this" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id
  tags = {
    Name = "146_default_network_acl_red1"
  }
  ingress {
    protocol   = "udp"
    rule_no    = 4
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1
    to_port    = 65535 
  }  
  ingress {
    protocol   = "udp"
    rule_no    = 40
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 1
    to_port    = 65535 
  } 
}
