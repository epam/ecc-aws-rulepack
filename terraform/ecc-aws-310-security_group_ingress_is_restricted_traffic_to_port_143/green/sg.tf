resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_security_group" "this" {
  name   = "310_security_group_green"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 143
    to_port     = 143
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}