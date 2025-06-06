resource "aws_s3_bucket" "this" {
  bucket        = "358-bucket-${random_integer.this.result}-green2"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
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
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = ["arn:aws:cloudtrail:${var.default-region}:${data.aws_caller_identity.this.account_id}:trail/${local.trail_name}"]
    }
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
      values = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = ["arn:aws:cloudtrail:${var.default-region}:${data.aws_caller_identity.this.account_id}:trail/${local.trail_name}"]
    }
  }
}
