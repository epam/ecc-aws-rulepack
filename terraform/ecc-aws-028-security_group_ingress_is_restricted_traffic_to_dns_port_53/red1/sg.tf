data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "028_security_group_red1"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "028_security_group_red1"
  }

  ingress {
    from_port   = 53
    to_port     = 53
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