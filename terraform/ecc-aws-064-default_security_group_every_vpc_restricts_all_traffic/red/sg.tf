resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id
  
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
}