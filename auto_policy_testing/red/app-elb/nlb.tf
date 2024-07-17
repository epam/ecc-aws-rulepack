resource "aws_lb" "this2" {
  name               = "${module.naming.resource_prefix.lb}-network-1"
  internal           = false
  load_balancer_type = "network"
  subnets            = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id ]
  desync_mitigation_mode     = "monitor"

  access_logs {
    bucket  = aws_s3_bucket.this.bucket
    enabled = true
  }
}

resource "aws_lb_target_group" "this2" {
  name     = "${module.naming.resource_prefix.lb}-tg-1"
  port     = 443
  protocol = "TCP"
  vpc_id   = aws_vpc.this.id
}

resource "aws_lb_listener" "this2" {
  load_balancer_arn = aws_lb.this2.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_iam_server_certificate.this.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this2.arn
  }
}
