resource "aws_security_group" "this1" {
  name        = "${module.naming.resource_prefix.security_group}-1"
  tags = {
    Name = "${module.naming.resource_prefix.security_group}-1"
  }
  vpc_id      = data.terraform_remote_state.common.outputs.vpc_id

  ingress {
    from_port   = 8140
    to_port     = 8140
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 20
    to_port     = 23
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "this2" {
  name        = "${module.naming.resource_prefix.security_group}-2"
  tags = {
    Name = "${module.naming.resource_prefix.security_group}-2"
  }
  vpc_id      = data.terraform_remote_state.common.outputs.vpc_id

}
resource "aws_security_group_rule" "rule1" {
  from_port = 8080
  to_port   = 8080
  protocol  = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.this2.id
  type              = "ingress"
}

resource "aws_security_group_rule" "rule2" {
  from_port = 3000
  to_port   = 3000
  protocol  = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.this2.id
  type              = "ingress"
}

resource "aws_security_group_rule" "rule3" {
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.this2.id
  type              = "egress"
}
