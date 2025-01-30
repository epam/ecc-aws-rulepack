data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "this" {
  state = "available"
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "availability-zone"
    values = data.aws_availability_zones.this.names
  }
  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

data "aws_security_group" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_security_group" "this" {
  name        = "005_security_group_red2"
  description = "Allow all inbound traffic"

  tags = {
    Name = "005_security_group_red2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "this1" {
  security_group_id = aws_security_group.this.id
  cidr_ipv6         = "::/0"
  from_port         = 100
  ip_protocol       = "tcp"
  to_port           = 100
}

resource "aws_vpc_security_group_ingress_rule" "this2" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = data.aws_vpc.default.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "this3" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_vpc_security_group_egress_rule" "this4" {
  security_group_id = aws_security_group.this.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" 
}

resource "aws_vpc_security_group_ingress_rule" "this5" {
  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = data.aws_security_group.this.id
  from_port                    = 443
  ip_protocol                  = "tcp"
  to_port                      = 443
}

resource "aws_vpc_security_group_ingress_rule" "this6" {
  security_group_id = aws_security_group.this.id
  prefix_list_id    = aws_ec2_managed_prefix_list.this.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_ec2_managed_prefix_list" "this" {
  name           = "005_prefix_list_red2"
  address_family = "IPv4"
  max_entries    = 5

  entry {
    cidr        = data.aws_vpc.default.cidr_block
    description = "test"
  }
}