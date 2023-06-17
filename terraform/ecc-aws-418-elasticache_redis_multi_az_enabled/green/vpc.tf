resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "this1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}


resource "aws_subnet" "this2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
}


resource "aws_elasticache_subnet_group" "this" {
  name       = "c7n-418-elasticache-subnet-green"
  subnet_ids = [aws_subnet.this1.id, aws_subnet.this2.id]
}
