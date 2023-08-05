resource "aws_vpc" "this" {
  cidr_block         = "10.0.0.0/16"
  enable_dns_support = true

  tags = {
    Name = "196_vpc_green"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public" {
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.this.id
}

resource "aws_security_group" "master_security_group" {
  name                   = "196_master_security_group_green"
  vpc_id                 = aws_vpc.this.id
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
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
  name                   = "196_slave_security_group_green"
  vpc_id                 = aws_vpc.this.id
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
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
  name   = "196_service_access_security_group_green"
  vpc_id = aws_vpc.this.id
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
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}
resource "aws_eip" "this" {
  vpc        = true
  depends_on = [aws_internet_gateway.this]
}
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_eip.this]
}

resource "aws_route_table" "route_table_internet_gateway" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  depends_on = [
    aws_vpc.this,
    aws_internet_gateway.this
  ]
}

resource "aws_route_table_association" "route_table_internet_gateway" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.route_table_internet_gateway.id
}

resource "aws_route_table" "route_table_nat_gateway" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  depends_on = [
    aws_vpc.this,
    aws_nat_gateway.this
  ]
}

resource "aws_route_table_association" "route_table_nat_gateway" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.route_table_nat_gateway.id
}