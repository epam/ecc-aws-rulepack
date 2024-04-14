resource "aws_security_group" "this" {
  name   = module.naming.resource_prefix.security_group
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
  tags = {
    Name = "${module.naming.resource_prefix.security_group}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_53" {
  security_group_id = aws_security_group.this.id

  from_port   = 53
  to_port     = 53
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_21" {
  security_group_id = aws_security_group.this.id

  from_port   = 21
  to_port     = 21
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_80" {
  security_group_id = aws_security_group.this.id

  from_port   = 80
  to_port     = 80
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_445" {
  security_group_id = aws_security_group.this.id

  from_port   = 445
  to_port     = 445
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_27017" {
  security_group_id = aws_security_group.this.id

  from_port   = 27017
  to_port     = 27017
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_3306" {
  security_group_id = aws_security_group.this.id

  from_port   = 3306
  to_port     = 3306
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_3389" {
  security_group_id = aws_security_group.this.id

  from_port   = 3389
  to_port     = 3389
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_139" {
  security_group_id = aws_security_group.this.id

  from_port   = 139
  to_port     = 139
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_1521" {
  security_group_id = aws_security_group.this.id

  from_port   = 1521
  to_port     = 1521
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_110" {
  security_group_id = aws_security_group.this.id

  from_port   = 110
  to_port     = 110
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_5432" {
  security_group_id = aws_security_group.this.id

  from_port   = 5432
  to_port     = 5432
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_20-25" {
  security_group_id = aws_security_group.this.id

  from_port   = 20
  to_port     = 25
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_135-143" {
  security_group_id = aws_security_group.this.id

  from_port   = 135
  to_port     = 143
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_1433-1434" {
  security_group_id = aws_security_group.this.id

  from_port   = 1433
  to_port     = 1434
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_4333" {
  security_group_id = aws_security_group.this.id

  from_port   = 4333
  to_port     = 4333
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_8999-9301" {
  security_group_id = aws_security_group.this.id

  from_port   = 8999
  to_port     = 9301
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_5500-5601" {
  security_group_id = aws_security_group.this.id

  from_port   = 5500
  to_port     = 5601
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_port_8080" {
  security_group_id = aws_security_group.this.id

  from_port   = 8080
  to_port     = 8080
  cidr_ipv4   = "178.67.8.4/32"
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "egress_port_0" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4   = data.terraform_remote_state.common.outputs.vpc_cidr_block
  ip_protocol = "-1"
}


resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${module.naming.resource_prefix.vpc}"
  }
}


resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id
}