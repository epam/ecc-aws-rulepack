resource "aws_lb" "alb" {
  name                   = "alb-755-green"
  load_balancer_type     = "application"
  subnets                = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  internal               = false
}

