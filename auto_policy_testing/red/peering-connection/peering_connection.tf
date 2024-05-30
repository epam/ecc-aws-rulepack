resource "aws_vpc_peering_connection" "this" {
  provider      = aws.provider2
  peer_owner_id = data.aws_caller_identity.this.account_id
  peer_vpc_id   = data.terraform_remote_state.common.outputs.vpc_id
  vpc_id        = aws_vpc.vpc.id
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.2.0.0/16"
}