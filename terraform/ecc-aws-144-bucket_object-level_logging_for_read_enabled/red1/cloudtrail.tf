data "aws_caller_identity" "this" {}

resource "aws_cloudtrail" "this" {
  name                          = "144_cloudtrail_red1"
  s3_bucket_name                = aws_s3_bucket.this.id
  include_global_service_events = true
  is_multi_region_trail         = true

  advanced_event_selector {
    field_selector {
      field  = "eventCategory"
      equals = ["Data"]
    }
    field_selector {
      field  = "resources.type"
      equals = ["AWS::S3::Object"]
    }
    field_selector {
      field  = "readOnly"
      equals = ["true"]
    }
    field_selector {
      field = "resources.ARN"

      equals = [
        "${aws_s3_bucket.this.arn}/"
      ]
    }
  }
  advanced_event_selector {
    field_selector {
      field  = "eventCategory"
      equals = ["Data"]
    }
    field_selector {
      field  = "resources.type"
      equals = ["AWS::S3::Object"]
    }
    field_selector {
      field = "eventName"

      equals = [
        "PutObject",
        "DeleteObject"
      ]
    }
  }
  advanced_event_selector {
    field_selector {
      field  = "eventCategory"
      equals = ["Management"]
    }
    field_selector {
      field  = "readOnly"
      equals = ["false"]
    }
  }
  advanced_event_selector {
    field_selector {
      field  = "eventCategory"
      equals = ["Management"]
    }
    field_selector {
      field  = "eventSource"
      not_equals = ["rdsdata.amazonaws.com"]
    }
  }
  depends_on = [
    aws_s3_bucket_policy.this,
    aws_s3_bucket.this
  ]
}

resource "aws_s3_bucket" "this" {
  bucket        = "144-bucket-${random_integer.this.result}-red1"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.this.arn]
  }
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this.arn}/AWSLogs/${data.aws_caller_identity.this.account_id}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cloudtrail:${var.default-region}:${data.aws_caller_identity.this.account_id}:trail/144_cloudtrail_red1"
      ]
    }
  }
}
