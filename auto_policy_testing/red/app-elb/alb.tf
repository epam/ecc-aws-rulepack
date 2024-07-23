resource "aws_lb" "this1" {
  name                       = "${module.naming.resource_prefix.lb}-app1"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.this1.id, aws_security_group.this2.id]
  subnets                    = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_2_id ]
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

resource "aws_lb_listener" "this3" {
  load_balancer_arn = aws_lb.this1.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.this2.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_certificate" "this" {
  listener_arn    = aws_lb_listener.this3.arn
  certificate_arn = aws_acm_certificate.this1.arn
}
