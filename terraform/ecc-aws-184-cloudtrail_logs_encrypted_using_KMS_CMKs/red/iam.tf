data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "kms" {
  statement {
    sid = "Allow root"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root",
      ]
    }
    actions = [
      "kms:*",
    ]
    resources = [
      "*",
    ]
  }
  statement {
    sid = "Allow CloudTrail to encrypt logs"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
    }
    actions = [
      "kms:GenerateDataKey*",
    ]
    resources = [
      "*",
    ]
    condition {
      test = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values = [
        "arn:aws:cloudtrail:*:${data.aws_caller_identity.this.account_id}:trail/*"
      ]
    }
  }
}

data "aws_iam_policy_document" "bucket" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
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