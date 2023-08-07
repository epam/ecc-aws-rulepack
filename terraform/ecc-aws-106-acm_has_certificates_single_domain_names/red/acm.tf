resource "aws_acm_certificate" "this" {
  domain_name       = "*.custodian.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
