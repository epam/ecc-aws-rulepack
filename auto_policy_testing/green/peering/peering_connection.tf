resource "aws_vpc_peering_connection" "this" {
  peer_owner_id = data.aws_caller_identity.this.account_id
  peer_vpc_id   = data.terraform_remote_state.common.outputs.vpc_id
  vpc_id        = aws_vpc.vpc.id
  auto_accept   = true
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.1.0.0/16"
}
