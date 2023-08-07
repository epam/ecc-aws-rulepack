resource "aws_s3_bucket" "this" {
  bucket = "083-bucket-${random_integer.this.result}-green"
}

locals {
  s3_origin_id = "myGreenS3"
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

  }

  enabled             = true
  default_root_object = "index.html"
  web_acl_id          = aws_waf_web_acl.this.id

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
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_waf_web_acl" "this" {
  name        = "waf-web-acl-083-green"
  metric_name = "GreenWebACL083"

  default_action {
    type = "ALLOW"
  }
}