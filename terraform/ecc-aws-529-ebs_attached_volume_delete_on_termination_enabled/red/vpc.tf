resource "aws_vpc" "this" {
  cidr_block = "192.168.43.0/28"
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = aws_vpc.this.cidr_block
  availability_zone = "${var.default-region}"
}

resource "aws_network_interface" "this" {
  subnet_id = aws_subnet.this.id
}