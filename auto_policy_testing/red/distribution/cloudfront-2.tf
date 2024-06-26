
resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "${module.naming.resource_prefix.cloudfront}-oai"
}
resource "aws_cloudfront_distribution" "this2" {
  origin {
    domain_name              = "not-${aws_s3_bucket.this.bucket_regional_domain_name}"
    origin_id                = "${module.naming.resource_prefix.cloudfront}-2"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }
  comment             = "${module.naming.resource_prefix.cloudfront}-2"
  enabled             = true

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${module.naming.resource_prefix.cloudfront}-2"
    viewer_protocol_policy = "allow-all"
    
    # Using the CachingDisabled managed policy ID
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}