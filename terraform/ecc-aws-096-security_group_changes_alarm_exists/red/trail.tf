data "aws_caller_identity" "this" {}

resource "aws_cloudtrail" "this" {
  name                       = "cloudtrail-096-red"
  s3_bucket_name             = aws_s3_bucket.this.id
  cloud_watch_logs_role_arn  = aws_iam_role.this.arn
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.this.arn}:*"
  depends_on = [
    aws_s3_bucket.this,
    aws_s3_bucket_policy.this,
  ]
}

resource "aws_s3_bucket" "this" {
  bucket        = "096-bucket-${random_integer.this.result}-red"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
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
        "arn:aws:cloudtrail:${var.default-region}:${data.aws_caller_identity.this.account_id}:trail/cloudtrail-096-red"
      ]
    }
  }
}