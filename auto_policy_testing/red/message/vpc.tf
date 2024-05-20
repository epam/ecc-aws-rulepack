resource "aws_security_group" "this" {
  name   = module.naming.resource_prefix.security_group
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.common.outputs.vpc_cidr_block]
  }
}