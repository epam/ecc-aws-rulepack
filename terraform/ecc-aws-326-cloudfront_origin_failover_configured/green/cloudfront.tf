resource "aws_s3_bucket" "primary" {
  bucket        = "primary-bucket-326-green"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "primary" {
  bucket = aws_s3_bucket.primary.id
  acl    = "private"
}

resource "aws_s3_bucket" "failover" {
  bucket        = "failover-bucket-326-green"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "failover" {
  bucket = aws_s3_bucket.failover.id
  acl    = "private"
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "origin_access_indentity_326_green"
}

resource "aws_cloudfront_distribution" "this" {
  origin_group {
    origin_id = "groupS3"

    failover_criteria {
      status_codes = [403, 404, 500, 502]
    }

    member {
      origin_id = "primaryS3"
    }

    member {
      origin_id = "failoverS3"
    }
  }

  origin {
    domain_name = aws_s3_bucket.primary.bucket_regional_domain_name
    origin_id   = "primaryS3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.failover.bucket_regional_domain_name
    origin_id   = "failoverS3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "groupS3"

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
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}