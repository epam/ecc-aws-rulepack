resource "aws_acm_certificate" "this" {
  domain_name       = "examplered.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
