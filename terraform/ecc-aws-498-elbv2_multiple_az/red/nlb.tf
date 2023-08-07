resource "aws_lb" "nlb" {
  name               = "nlb-498-red"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.subnet.id]
}