resource "aws_security_group" "this" {
  name   = module.naming.resource_prefix.security_group
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${module.naming.resource_prefix.security_group}"
  }
}