resource "aws_lb" "this" {
  name                       = "alb-809-Red"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.this.id]
  subnets                    = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  internal                   = false
  enable_deletion_protection = false
  # subnet_mapping   {
  #   subnet_id     = aws_subnet.subnet1.id
  #   allocation_id = aws_eip.this.id
  # }
  # subnet_mapping  {
  #   subnet_id     = aws_subnet.subnet2.id
  #   allocation_id = aws_eip.this1.id
  # }
}

resource "aws_vpc" "this" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "this" {
  name   = "809_security_group_red"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

# resource "aws_eip" "this" {
#   vpc   = true
# }

# resource "aws_eip" "this1" {
#   vpc   = true
# }