data "aws_caller_identity" "this" {}

resource "aws_cloudtrail" "this" {
  name                          = "c7n-084-cloudtrail-green"
  s3_bucket_name                = aws_s3_bucket.this.id
  is_multi_region_trail         = true
}

resource "aws_s3_bucket" "bucket_for_logging" {
  bucket = "c7n-084-bucket-for-logging-${random_integer.this.result}-green"
  force_destroy = true
}

resource "aws_s3_bucket" "this" {
  bucket        = "084-bucket-${random_integer.this.result}-green"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_logging" "this" {
  bucket        = aws_s3_bucket.this.id
  target_bucket = aws_s3_bucket.bucket_for_logging.id
  target_prefix = "log/"
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
    resources = [aws_s3_bucket.this.arn]
  }

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
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



resource "aws_s3_bucket_policy" "bucket_for_logging" {
  bucket = aws_s3_bucket.bucket_for_logging.id
  policy = data.aws_iam_policy_document.bucket_for_logging.json
}

data "aws_iam_policy_document" "bucket_for_logging" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.bucket_for_logging.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      
      values = [
        data.aws_caller_identity.this.account_id
      ]
    }
  }
}
