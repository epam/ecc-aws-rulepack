resource "aws_lb" "nlb" {
  name               = "nlb-755-green"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}
