resource "aws_security_group" "this" {
  name   = "workstation_security_group"
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.common.outputs.vpc_cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "this2" {
  name   = "workstation_security_group2"
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.common.outputs.vpc_cidr_block]
  }
}
