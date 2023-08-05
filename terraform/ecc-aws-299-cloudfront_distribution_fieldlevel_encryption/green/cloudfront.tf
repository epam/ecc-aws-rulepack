resource "aws_s3_bucket" "this" {
  bucket = "299-bucket-${random_integer.this.result}-green"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

locals {
  s3_origin_id = "myGreenS3"
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 2048 
}

resource "aws_cloudfront_public_key" "this" {
  comment     = "299_public_key_green"
  encoded_key = tls_private_key.this.public_key_pem
  name        = "299_public_key_green"
}

resource "aws_cloudfront_field_level_encryption_profile" "this" {
  name = "299_cloudfront_field_level_encryption_profile_green"

  encryption_entities {
    items {
      public_key_id = aws_cloudfront_public_key.this.id
      provider_id   = "299_provider_green"

      field_patterns {
        items = ["CreditCardNumber"]
      }
    }
  }
}

resource "aws_cloudfront_field_level_encryption_config" "this" {
  comment = "299_cloudfront_field_level_encryption_config_green"
  content_type_profile_config {
    forward_when_content_type_is_unknown = true

    content_type_profiles {
      items {
        content_type = "application/x-www-form-urlencoded"
        format       = "URLEncoded"
      }
    }
  }

  query_arg_profile_config {
    forward_when_query_arg_profile_is_unknown = true

    query_arg_profiles {
      items {
        profile_id = aws_cloudfront_field_level_encryption_profile.this.id
        query_arg  = "Arg1"
      }
    }
  }
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    field_level_encryption_id = aws_cloudfront_field_level_encryption_config.this.id
    allowed_methods           = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods            = ["GET", "HEAD"]
    target_origin_id          = local.s3_origin_id

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
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}