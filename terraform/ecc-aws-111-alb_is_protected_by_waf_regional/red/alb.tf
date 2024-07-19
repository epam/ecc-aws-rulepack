resource "aws_lb" "this" {
  name               = "alb-111-red"
  load_balancer_type = "application"
  subnets            = [data.aws_subnets.this.ids[0], data.aws_subnets.this.ids[1]]
}
data "aws_vpc" "this" {
  default = true
} 

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}