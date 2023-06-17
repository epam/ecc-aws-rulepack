resource "aws_lb" "nlb" {
  name               = "nlb-755-red"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.subnet.id]
}