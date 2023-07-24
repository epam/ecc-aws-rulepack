resource "aws_lb" "this" {
  name               = "410-nlb-green"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.this.id, aws_subnet.this1.id]
  enable_deletion_protection = false
}

resource "aws_vpc_endpoint_service" "this" {
  acceptance_required        = true
  network_load_balancer_arns = [aws_lb.this.arn]
}
