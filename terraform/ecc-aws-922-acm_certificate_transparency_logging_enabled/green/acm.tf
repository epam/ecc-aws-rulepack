resource "aws_acm_certificate" "this" {
  domain_name       = "examplegreen.com"
  validation_method = "DNS"

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }
  lifecycle {
    create_before_destroy = true
  }
}
