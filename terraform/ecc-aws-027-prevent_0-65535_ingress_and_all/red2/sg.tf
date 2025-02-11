data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "027_security_group_red2"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "027_security_group_red2"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    ipv6_cidr_blocks = ["FE80::/10"]
  }
}