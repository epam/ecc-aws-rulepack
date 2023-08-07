resource "aws_lb" "this" {
  name               = "262-nlb-red"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.this.id, aws_subnet.this1.id]
  enable_deletion_protection = false
}

resource "aws_vpc_endpoint_service" "this" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.this.arn]
}
