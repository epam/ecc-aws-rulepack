resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}