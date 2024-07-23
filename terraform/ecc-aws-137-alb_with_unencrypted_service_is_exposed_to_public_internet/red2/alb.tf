resource "aws_lb" "this" {
  name               = "137-alb-red2"
  load_balancer_type = "application"
  subnets            = [data.aws_subnets.this.ids[0], data.aws_subnets.this.ids[1]]
  security_groups    = [aws_security_group.group1.id]
}

resource "aws_security_group" "group1" {
  name   = "137_security_group1_red"
  vpc_id = data.aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
}