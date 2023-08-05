resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "538_origin_access_control_red"
  description                       = "origin_access_indentity_538_red"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name              = "no-bucket-538-red.s3.amazonaws.com"
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "UA"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}