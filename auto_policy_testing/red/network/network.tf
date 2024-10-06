resource "aws_network_acl" "this" {
  provider = aws.provider2
  vpc_id   = data.terraform_remote_state.common.outputs.vpc_id

  ingress {
    protocol   = "tcp"
    rule_no    = 1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 2
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 3000
    to_port    = 4000
  }
}

resource "aws_eip" "this" {
  tags = {
    Name = "${module.naming.resource_prefix.eip}"
  }
}

