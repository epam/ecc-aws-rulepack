resource "aws_elb" "this1" {
  name                        = "${module.naming.resource_prefix.lb}-1"
  subnets                     = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_2_id]
  security_groups             = [aws_security_group.this1.id, aws_security_group.this2.id]
  connection_draining         = true
  connection_draining_timeout = 400
  desync_mitigation_mode      = "defensive"
  cross_zone_load_balancing   = true
  internal                    = true

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
    ssl_certificate_id = aws_acm_certificate.this.arn
  }

  listener {
    instance_port      = 8001
    instance_protocol  = "tcp"
    lb_port            = 444
    lb_protocol        = "ssl"
    ssl_certificate_id = aws_acm_certificate.this.arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  access_logs {
    bucket   = aws_s3_bucket.this.id
    interval = 60
  }

  instances = ["${aws_instance.this.id}"]

  depends_on = [time_sleep.wait_10_seconds]
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
    name  = "Protocol-TLSv1.2"
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

resource "aws_load_balancer_listener_policy" "this3" {
  load_balancer_name = aws_elb.this1.name
  load_balancer_port = 444

  policy_names = [
    aws_load_balancer_policy.this1.policy_name
  ]
}