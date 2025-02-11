data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "028_security_group_red3"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "028_security_group_red3"
  }

  ingress {
    from_port   = 2
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}