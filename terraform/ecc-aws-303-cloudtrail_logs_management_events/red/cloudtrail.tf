data "aws_caller_identity" "this" {}

resource "aws_cloudtrail" "this" {
  name                          = "303_cloudtrail_red"
  s3_bucket_name                = aws_s3_bucket.this.id
  include_global_service_events = false

  event_selector {
    include_management_events = false
    read_write_type           = "WriteOnly"
    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  
  }
  depends_on = [
      aws_s3_bucket.this,
      aws_s3_bucket_policy.this,
    ]
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
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
  }
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket" "this" {
  bucket        = "303-bucket-${random_integer.this.result}-red"
  force_destroy = true
}
