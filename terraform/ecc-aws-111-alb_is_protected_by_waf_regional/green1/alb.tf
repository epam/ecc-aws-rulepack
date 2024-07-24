resource "aws_lb" "this" {
  name               = "alb-111-green1"
  load_balancer_type = "application"
  subnets            = [data.aws_subnets.this.ids[0], data.aws_subnets.this.ids[1]]
}