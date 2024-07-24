resource "aws_lb" "this" {
  name               = "010-lb-https-red"
  load_balancer_type = "application"
  subnets            = [data.aws_subnets.this.ids[0], data.aws_subnets.this.ids[1]]
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.this.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_certificate" "this1" {
  listener_arn    = aws_lb_listener.this.arn
  certificate_arn = aws_acm_certificate.this.arn
}

resource "aws_lb_listener_certificate" "this2" {
  listener_arn    = aws_lb_listener.this.arn
  certificate_arn = aws_iam_server_certificate.this.arn
}