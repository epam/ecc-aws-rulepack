resource "aws_lb" "this" {
  name                       = "alb-195-red"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.this.id]
  subnets                    = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  internal                   = true
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "81"
      protocol    = "HTTP"
      status_code = "HTTP_301"
    }

  }
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
  name        = "195_security_group_green"
  vpc_id      = aws_vpc.this.id
}

resource "aws_security_group_rule" "rule1" {
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
    security_group_id = aws_security_group.this.id
  }

resource "aws_security_group_rule" "rule2" {
    type        = "egress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
    security_group_id = aws_security_group.this.id
  }

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}
