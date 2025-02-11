data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "028_security_group_green2"
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "028_security_group_green2"
  }
}

