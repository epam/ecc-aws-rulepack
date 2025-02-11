data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "031_security_group_green"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "031_security_group_green"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/32", "10.10.10.0/32"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    ipv6_cidr_blocks = ["FE80::/10"]
  }
  ingress {
    from_port   = 1000
    to_port     = 1000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 1000
    to_port     = 1050
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

