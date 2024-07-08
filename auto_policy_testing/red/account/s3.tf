resource "random_integer" "this" {
  min = 10000
  max = 99999
}

resource "aws_s3_bucket" "this1" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}-1"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "this1" {
  bucket = aws_s3_bucket.this1.id
  policy = data.aws_iam_policy_document.this1.json
}

data "aws_iam_policy_document" "this1" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.this1.arn]
  }
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this1.arn}/AWSLogs/${data.aws_caller_identity.this.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}
