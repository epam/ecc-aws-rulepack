resource "aws_security_group" "this1" {
  name   = "${module.naming.resource_prefix.security_group}-1"
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
  ingress {
    from_port = 1000
    to_port   = 15000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${module.naming.resource_prefix.security_group}-1"
  }
}

resource "aws_security_group" "this2" {
  name   = "${module.naming.resource_prefix.security_group}-2"
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
  ingress {
    from_port = 1000
    to_port   = 15000
    protocol  = "udp"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${module.naming.resource_prefix.security_group}-2"
  }
}