data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "027_security_group_red1"
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "027_security_group_red1"
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/32", "10.10.10.0/32"]
  }
}