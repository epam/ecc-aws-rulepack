resource "aws_s3_bucket" "this" {
  bucket = "bucket-242-green"
  force_destroy = "true"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

locals {
  s3_origin_id = "mygreenS3"
}

data "aws_caller_identity" "this" {
  provider = aws
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "s3:GetBucketACL",
      "s3:PutBucketACL",
    ]

    resources = [
      "arn:aws:s3:::bucket-242-green",
    ]

    principals {
      type = "AWS"

      identifiers = [
        data.aws_caller_identity.this.account_id,
      ]
    }
  }
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"

  logging_config {
    include_cookies = true
    bucket          = aws_s3_bucket.this.bucket_regional_domain_name
    prefix          = "myprefix"
  }

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

resource "aws_cloudfront_origin_access_identity" "this" {
  provider = aws
  comment  = "242_cloudfront_origin_access_identity_green"
}
