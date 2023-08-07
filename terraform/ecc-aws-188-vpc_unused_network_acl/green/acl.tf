resource "aws_vpc" "this" {
  cidr_block         = "10.0.0.0/16"
}

resource "aws_network_acl" "this" {
  vpc_id             = aws_vpc.this.id
  subnet_ids         = [aws_subnet.this.id]
}

resource "aws_subnet" "this" {
  vpc_id             = aws_vpc.this.id
  cidr_block         = "10.0.1.0/24"
  availability_zone  = "us-east-1a"
}
