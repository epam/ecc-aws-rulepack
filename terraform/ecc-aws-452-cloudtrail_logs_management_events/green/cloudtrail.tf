data "aws_caller_identity" "this" {}

resource "aws_cloudtrail" "this" {
  name                          = "452_cloudtrail_green"
  s3_bucket_name                = aws_s3_bucket.this.id
  include_global_service_events = false

  event_selector {
    include_management_events = true
    read_write_type           = "WriteOnly"
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
    resources = ["arn:aws:s3:::c7n-452-bucket-green"]
  }
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::c7n-452-bucket-green/AWSLogs/${data.aws_caller_identity.this.account_id}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}


resource "aws_s3_bucket" "this" {
  bucket        = "c7n-452-bucket-green"
  force_destroy = true
}
