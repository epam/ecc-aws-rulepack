resource "aws_lb" "glb" {
  name               = "glb-498-red"
  internal           = false
  load_balancer_type = "gateway"
  subnets            = [aws_subnet.subnet.id]
}