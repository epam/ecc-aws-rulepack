resource "aws_s3_bucket" "this" {
  bucket        = "358-bucket-${random_integer.this.result}-green1"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
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
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        "arn:aws:cloudtrail:${var.default-region}:${data.aws_caller_identity.this.account_id}:trail/cloudtrail-358-green1"
      ]
    }
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
      variable = "AWS:SourceArn"

      values = [
        "arn:aws:cloudtrail:${var.default-region}:${data.aws_caller_identity.this.account_id}:trail/cloudtrail-358-green1"
      ]
    }
  }
}
