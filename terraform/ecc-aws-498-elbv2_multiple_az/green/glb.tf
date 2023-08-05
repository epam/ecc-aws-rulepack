resource "aws_lb" "glb" {
  name               = "glb-498-green"
  internal           = false
  load_balancer_type = "gateway"
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}
