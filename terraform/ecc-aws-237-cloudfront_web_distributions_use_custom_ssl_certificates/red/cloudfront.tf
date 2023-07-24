resource "aws_s3_bucket" "this" {
  bucket = "237-bucket-${random_integer.this.result}-red"
  force_destroy = "true"
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

locals {
  s3_origin_id = "myRedS3"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
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
      restriction_type = "none"
    }
  }

  tags = {
    Name = "237_cloudfront_red"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}