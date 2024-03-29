data "aws_caller_identity" "this" {}

resource "aws_cloudtrail" "this" {
  name                          = "c7n-079-cloudtrail-red1"
  s3_bucket_name                = aws_s3_bucket.this.id
  cloud_watch_logs_role_arn     = aws_iam_role.this.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.this.arn}:*"
  depends_on = [
    aws_s3_bucket.this,
    aws_s3_bucket_policy.this,
  ]
}

resource "aws_s3_bucket" "this" {
  bucket        = "c7n-079-bucket-red1"
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
    resources = ["arn:aws:s3:::c7n-079-bucket-red1"]
  }
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::c7n-079-bucket-red1/AWSLogs/${data.aws_caller_identity.this.account_id}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}