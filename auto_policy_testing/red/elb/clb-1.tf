resource "aws_elb" "this1" {
  provider                  = aws.provider2
  name                      = "${module.naming.resource_prefix.lb}-1"
  subnets                   = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]
  security_groups           = [aws_security_group.this1.id, aws_security_group.this2.id]
  desync_mitigation_mode    = "monitor"
  cross_zone_load_balancing = false
  internal                  = false

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = aws_iam_server_certificate.this.arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  instances = ["${aws_instance.this.id}"]

  depends_on = [time_sleep.wait_20_seconds]
}
resource "aws_load_balancer_policy" "this1" {
  load_balancer_name = aws_elb.this1.name
  policy_name        = "${module.naming.resource_prefix.lb}-1"
  policy_type_name   = "SSLNegotiationPolicyType"

  policy_attribute {
    name  = "ECDHE-ECDSA-AES128-GCM-SHA256"
    value = "true"
  }

  policy_attribute {
    name  = "Protocol-SSLv3"
    value = "true"
  }
}

resource "aws_load_balancer_listener_policy" "this1" {
  load_balancer_name = aws_elb.this1.name
  load_balancer_port = 443

  policy_names = [
    aws_load_balancer_policy.this1.policy_name
  ]
}