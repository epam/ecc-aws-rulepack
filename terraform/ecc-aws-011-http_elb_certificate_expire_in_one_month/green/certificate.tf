resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "this" {
  private_key_pem = tls_private_key.this.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 800

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

resource "aws_iam_server_certificate" "this" {
  name             = "${module.naming.resource_prefix.acm}"
  certificate_body = tls_self_signed_cert.this.cert_pem
  private_key      = tls_private_key.this.private_key_pem
}

