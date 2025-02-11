data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "027_security_group_green"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "027_security_group_green"
  }
  ingress {
    from_port   = 1
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/32", "10.10.10.0/32"]
  }
  ingress {
    from_port   = 10
    to_port     = 200
    protocol    = "udp"
    ipv6_cidr_blocks = ["FE80::/10"]
  }
}