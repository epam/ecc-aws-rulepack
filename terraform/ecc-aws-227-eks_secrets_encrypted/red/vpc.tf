resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "227_aws_vpc_red"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.this.id

  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.this.id

  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}