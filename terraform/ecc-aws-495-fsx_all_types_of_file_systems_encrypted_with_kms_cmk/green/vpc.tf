resource "aws_vpc" "this" {
  cidr_block = "192.166.0.0/16"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "this1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "192.166.0.0/24"
  availability_zone = "us-east-1a"
}
resource "aws_subnet" "this2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "192.166.1.0/24"
  availability_zone = "us-east-1b"
}