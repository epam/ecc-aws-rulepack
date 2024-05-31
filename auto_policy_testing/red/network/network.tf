resource "aws_network_acl" "this" {
  provider = aws.provider2
  vpc_id   = data.terraform_remote_state.common.outputs.vpc_id
}

resource "aws_eip" "this" {
  tags = {
    Name = "${module.naming.resource_prefix.eip}"
  }
}

