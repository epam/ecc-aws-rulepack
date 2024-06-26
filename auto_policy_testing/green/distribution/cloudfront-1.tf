resource "aws_cloudfront_origin_access_control" "this" {
  origin_access_control_origin_type = "s3"
  name                              = "${module.naming.resource_prefix.cloudfront}-oac"
  description                       = "CloudFront access to S3"

  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "this1" {
  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = "${module.naming.resource_prefix.cloudfront}-1"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }
  origin {
    domain_name              = aws_s3_bucket.this2.bucket_regional_domain_name
    origin_id                = "${module.naming.resource_prefix.cloudfront}-failover"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  origin_group {
    origin_id = "groupS3"

    failover_criteria {
      status_codes = [403, 404, 500, 502]
    }

    member {
      origin_id = "${module.naming.resource_prefix.cloudfront}-1"
    }

    member {
      origin_id = "${module.naming.resource_prefix.cloudfront}-failover"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "/index.html"
  comment = "${module.naming.resource_prefix.cloudfront}-1"
  web_acl_id          = data.terraform_remote_state.common.outputs.waf_web_acl_id

  default_cache_behavior {
    field_level_encryption_id = aws_cloudfront_field_level_encryption_config.this.id
    target_origin_id         = "${module.naming.resource_prefix.cloudfront}-1"
    compress                 = true
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD"]
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = data.aws_cloudfront_cache_policy.this.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.this.id
    realtime_log_config_arn  = aws_cloudfront_realtime_log_config.this.arn
  }

  ordered_cache_behavior {
    field_level_encryption_id = aws_cloudfront_field_level_encryption_config.this.id
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
    viewer_protocol_policy = "https-only"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }
  
  logging_config {
    include_cookies = true
    bucket          = aws_s3_bucket.this.bucket_regional_domain_name
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = [ aws_s3_bucket_policy.this, aws_s3_bucket_acl.this ]
}

data "aws_cloudfront_origin_request_policy" "this" {
  name = "Managed-CORS-S3Origin"
}

data "aws_cloudfront_cache_policy" "this" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_realtime_log_config" "this" {
  name = "${module.naming.resource_prefix.cloudfront}-log-config"

  fields        = ["timestamp", "c-ip"]
  sampling_rate = 100

  endpoint {
    stream_type = "Kinesis"

    kinesis_stream_config {
      role_arn   = aws_iam_role.this.arn
      stream_arn = aws_kinesis_stream.this.arn
    }
  }
}

resource "aws_cloudfront_public_key" "this" {
  comment     = "${module.naming.resource_prefix.cloudfront}-pub-key"
  encoded_key = tls_private_key.this.public_key_pem
  name        = "${module.naming.resource_prefix.cloudfront}-pub-key"
}

resource "aws_cloudfront_field_level_encryption_profile" "this" {
  name = "${module.naming.resource_prefix.cloudfront}"

  encryption_entities {
    items {
      public_key_id = aws_cloudfront_public_key.this.id
      provider_id   = "test"

      field_patterns {
        items = ["CreditCardNumber"]
      }
    }
  }
}

resource "aws_cloudfront_field_level_encryption_config" "this" {
  comment = "${module.naming.resource_prefix.cloudfront}"
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