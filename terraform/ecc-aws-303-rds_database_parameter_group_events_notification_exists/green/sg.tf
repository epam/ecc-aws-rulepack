data "aws_vpc" "this" {
  default = true
} 
resource "aws_security_group" "this" {
  name        = "303_security_group_green"
  description = "Allow MYSQL/Aurora inbound traffic"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

