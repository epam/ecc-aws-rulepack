resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "t2.micro"
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_elb" "this" {
  name               = "elb-092-http-green"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = aws_acm_certificate.this.arn
  }

  instances                   = ["${aws_instance.this.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "this" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.this.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "this" {
  private_key      = tls_private_key.this.private_key_pem
  certificate_body = tls_self_signed_cert.this.cert_pem
}

resource "aws_load_balancer_policy" "this" {
  load_balancer_name = aws_elb.this.name
  policy_name        = "policygreen"
  policy_type_name   = "SSLNegotiationPolicyType"

  policy_attribute {
    name  = "Reference-Security-Policy"
    value = "ELBSecurityPolicy-TLS-1-2-2017-01"
  }
}

resource "aws_load_balancer_listener_policy" "this" {
  load_balancer_name = aws_elb.this.name
  load_balancer_port = 443

  policy_names = [
    aws_load_balancer_policy.this.policy_name,
  ]
}