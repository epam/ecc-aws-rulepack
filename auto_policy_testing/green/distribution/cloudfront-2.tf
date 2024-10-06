resource "aws_cloudfront_distribution" "this2" {
  origin {
    domain_name              = aws_s3_bucket_website_configuration.this.website_endpoint
    origin_id                = "${module.naming.resource_prefix.cloudfront}-2"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  comment             = "${module.naming.resource_prefix.cloudfront}-2"
  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    field_level_encryption_id = aws_cloudfront_field_level_encryption_config.this.id
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${module.naming.resource_prefix.cloudfront}-2"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "UA"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.this.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}
