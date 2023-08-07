resource "aws_acm_certificate" "this" {
  domain_name       = "examplegreen.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
