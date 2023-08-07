resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "187_vpc_red"
  }
}

resource "aws_security_group" "this" {
  name        = "187_security_group_red"
  description = "187_security_group_description_red"
}

resource "aws_vpc_endpoint" "this" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.this.id,
  ]

  depends_on = [aws_security_group.this, aws_vpc.this]
}