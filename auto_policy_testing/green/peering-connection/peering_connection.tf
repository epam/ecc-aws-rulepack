resource "aws_vpc_peering_connection" "this" {
  peer_owner_id = data.aws_caller_identity.this.account_id
  peer_vpc_id   = aws_vpc.vpc1.id
  vpc_id        = aws_vpc.vpc2.id
  auto_accept   = true
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_vpc" "vpc2" {
  cidr_block = "10.2.0.0/16"
}