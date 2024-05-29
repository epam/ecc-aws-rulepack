resource "aws_network_acl" "this" {
  vpc_id   = data.terraform_remote_state.common.outputs.vpc_id
  provider = aws.provider2
}

resource "aws_eip" "this" { }

