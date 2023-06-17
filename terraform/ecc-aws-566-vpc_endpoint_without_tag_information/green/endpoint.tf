resource "aws_vpc_endpoint" "this" {
  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.us-east-1.s3"
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}