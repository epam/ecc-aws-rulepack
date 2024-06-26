resource "aws_cloudfront_distribution" "this1" {
  provider                      = aws.provider2
  origin {
    domain_name              = "${aws_s3_bucket.this.bucket_regional_domain_name}"
    origin_id                = "${module.naming.resource_prefix.cloudfront}-1"
  }

  enabled             = true
  comment             = "${module.naming.resource_prefix.cloudfront}-1"

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${module.naming.resource_prefix.cloudfront}-1"
    viewer_protocol_policy = "allow-all"

    # Using the CachingDisabled managed policy ID
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  }

  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${module.naming.resource_prefix.cloudfront}-1"

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
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.this.arn
    ssl_support_method             = "vip"
    minimum_protocol_version       = "TLSv1"
  }
}