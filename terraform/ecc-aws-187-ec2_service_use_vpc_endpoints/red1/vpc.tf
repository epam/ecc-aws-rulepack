resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "187_vpc_red1"
  }
}