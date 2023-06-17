resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  lb_target_group_arn   = aws_lb_target_group.this.arn
}

resource "aws_lb_target_group" "this" {
  name     = "lb-433-green1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
}

resource "aws_vpc" "this" {
  cidr_block = "10.10.0.0/16"
}

