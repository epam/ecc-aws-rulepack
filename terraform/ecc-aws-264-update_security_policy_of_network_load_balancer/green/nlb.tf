resource "aws_lb" "this" {
  name               = "nlb-264-green"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

###### The step to be done before run infrastructure is to run command below
# openssl req -x509 -nodes -days 32 -newkey rsa:2048 -keyout private.key -out certificate.crt 


resource "aws_lb_target_group" "this" {
  name     = "lb-target-group-264-green"
  port     = 443
  protocol = "TCP"
  vpc_id   = aws_vpc.this.id
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_iam_server_certificate.this.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_iam_server_certificate" "this" {
  name             = "264_certificate_green"
  certificate_body = file("certificate.crt")
  private_key      = file("private.key")
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
  name   = "264_security_group_green"
  vpc_id = aws_vpc.this.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rule1" {
  from_port = 443
  protocol  = "tcp"
  to_port   = 443
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = aws_security_group.this.id
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_egress_all" {
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = aws_security_group.this.id
  type              = "egress"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}
