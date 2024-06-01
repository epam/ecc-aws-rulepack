resource "aws_security_group" "master_security_group" {
  name                   = "${module.naming.resource_prefix.security_group}-master"
  vpc_id                 = data.terraform_remote_state.common.outputs.vpc_id
  revoke_rules_on_delete = true
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "udp"
    self      = true
  }
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }
  ingress {
    from_port = "-1"
    to_port   = "-1"
    protocol  = "icmp"
    self      = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    for-use-with-amazon-emr-managed-policies = true
  }
}


resource "aws_security_group_rule" "master_sg_ingress1" {
  type                     = "ingress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.master_security_group.id
  source_security_group_id = aws_security_group.service_access_security_group.id
}

resource "aws_security_group_rule" "master_sg_ingress2" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.master_security_group.id
  source_security_group_id = aws_security_group.slave_security_group.id
}

resource "aws_security_group_rule" "master_sg_ingress3" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.master_security_group.id
  source_security_group_id = aws_security_group.slave_security_group.id
}

resource "aws_security_group_rule" "master_sg_ingress4" {
  type                     = "ingress"
  from_port                = "-1"
  to_port                  = "-1"
  protocol                 = "icmp"
  security_group_id        = aws_security_group.master_security_group.id
  source_security_group_id = aws_security_group.slave_security_group.id
}

resource "aws_security_group_rule" "master_sg_ingress5" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "udp"
  security_group_id        = aws_security_group.master_security_group.id
  source_security_group_id = aws_security_group.slave_security_group.id
}

resource "aws_security_group" "slave_security_group" {
  name                   = "${module.naming.resource_prefix.security_group}-slave"
  vpc_id                 = data.terraform_remote_state.common.outputs.vpc_id
  revoke_rules_on_delete = true
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "udp"
    self      = true
  }
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }
  ingress {
    from_port = "-1"
    to_port   = "-1"
    protocol  = "icmp"
    self      = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    for-use-with-amazon-emr-managed-policies = true
  }
}

resource "aws_security_group_rule" "slave_sg_ingress1" {
  type                     = "ingress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.slave_security_group.id
  source_security_group_id = aws_security_group.service_access_security_group.id
}

resource "aws_security_group_rule" "slave_sg_ingress2" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.slave_security_group.id
  source_security_group_id = aws_security_group.master_security_group.id
}

resource "aws_security_group_rule" "slave_sg_ingress3" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.slave_security_group.id
  source_security_group_id = aws_security_group.master_security_group.id
}

resource "aws_security_group_rule" "slave_sg_ingress4" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "udp"
  security_group_id        = aws_security_group.slave_security_group.id
  source_security_group_id = aws_security_group.master_security_group.id
}

resource "aws_security_group_rule" "slave_sg_ingress5" {
  type                     = "ingress"
  from_port                = "-1"
  to_port                  = "-1"
  protocol                 = "icmp"
  security_group_id        = aws_security_group.slave_security_group.id
  source_security_group_id = aws_security_group.master_security_group.id
}

resource "aws_security_group" "service_access_security_group" {
  name   = "${module.naming.resource_prefix.security_group}-service"
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id

  tags = {
    for-use-with-amazon-emr-managed-policies = true
  }
}

resource "aws_security_group_rule" "service_access_sg_ingress" {
  type                     = "ingress"
  from_port                = 9443
  to_port                  = 9443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.service_access_security_group.id
  source_security_group_id = aws_security_group.master_security_group.id
}

resource "aws_security_group_rule" "service_access_sg_egress1" {
  type                     = "egress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.service_access_security_group.id
  source_security_group_id = aws_security_group.master_security_group.id
}

resource "aws_security_group_rule" "service_access_sg_egress2" {
  type                     = "egress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.service_access_security_group.id
  source_security_group_id = aws_security_group.slave_security_group.id
}