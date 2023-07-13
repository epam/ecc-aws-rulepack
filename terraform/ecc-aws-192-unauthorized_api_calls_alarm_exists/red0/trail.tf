data "aws_caller_identity" "this" {}

resource "aws_cloudtrail" "this" {
  name                          = "c7n-192-cloudtrail-red0"
  s3_bucket_name                = aws_s3_bucket.this.id
  include_global_service_events = true
  is_multi_region_trail         = true
  depends_on = [
    aws_s3_bucket.this,
    aws_s3_bucket_policy.this
  ]
}

resource "aws_s3_bucket" "this" {
  bucket        = "c7n-192-bucket-red0"
  force_destroy = true
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
      actions = ["s3:GetBucketAcl"]
      resources = ["arn:aws:s3:::c7n-192-bucket-red0"]
  }
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::c7n-192-bucket-red0/AWSLogs/${data.aws_caller_identity.this.account_id}/*"]
    
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}