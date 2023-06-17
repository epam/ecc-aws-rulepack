resource "aws_acm_certificate" "this" {
  domain_name       = "examplered.com"
  validation_method = "DNS"

  options {
    certificate_transparency_logging_preference = "DISABLED"
  }
  lifecycle {
    create_before_destroy = true
  }
}
