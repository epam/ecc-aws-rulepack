data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name   = "013_security_group_green"
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "013_security_group_green"
  }
}