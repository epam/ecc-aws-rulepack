resource "aws_security_group" "this" {
  name   = module.naming.resource_prefix.security_group
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id

  ingress {
    from_port   = 8162
    to_port     = 8162
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.common.outputs.vpc_cidr_block]
  }
  ingress {
    from_port   = 61617
    to_port     = 61617
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.common.outputs.vpc_cidr_block]
  }
}