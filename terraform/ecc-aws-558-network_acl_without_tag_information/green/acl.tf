resource "aws_vpc" "this" {
  cidr_block         = "10.0.0.0/16"
}

resource "aws_network_acl" "this" {
  vpc_id             = aws_vpc.this.id
}
