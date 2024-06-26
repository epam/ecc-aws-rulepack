resource "aws_cloudfront_distribution" "this4" {
  origin {
    domain_name              = "${aws_s3_bucket_website_configuration.this.website_endpoint}"
    origin_id                = "${module.naming.resource_prefix.cloudfront}-4"

    custom_origin_config{
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.1"]
    }
  }
  comment             = "${module.naming.resource_prefix.cloudfront}-4"
  enabled             = true

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${module.naming.resource_prefix.cloudfront}-4"
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