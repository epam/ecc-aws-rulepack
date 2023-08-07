resource "aws_nat_gateway" "this" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.this.id
}
resource "aws_vpc" "this" {
  cidr_block = "192.168.0.0/22"
}

data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_subnet" "this" {
  availability_zone = data.aws_availability_zones.this.names[0]
  cidr_block        = "192.168.0.0/24"
  vpc_id            = aws_vpc.this.id
}
