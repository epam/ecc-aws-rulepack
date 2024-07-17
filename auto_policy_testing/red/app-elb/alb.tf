resource "aws_lb" "this1" {
  name                       = "${module.naming.resource_prefix.lb}-app-1"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.this1.id, aws_security_group.this2.id]
  subnets                    = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id ]
  internal                   = false
  desync_mitigation_mode     = "monitor"
}

resource "aws_lb_listener" "this1" {
  load_balancer_arn = aws_lb.this1.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "81"
      protocol    = "HTTP"
      status_code = "HTTP_301"
    }
  }
}
