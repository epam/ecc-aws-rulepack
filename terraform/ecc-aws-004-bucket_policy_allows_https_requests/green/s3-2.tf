resource "aws_s3_bucket" "this2" {
  bucket        = "004-bucket-${random_integer.this.result}-green-2"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "this2" {
  bucket = aws_s3_bucket.this2.id
  policy = data.aws_iam_policy_document.this2.json
}

data "aws_iam_policy_document" "this2" {
  statement {
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["*"]
    resources = ["${aws_s3_bucket.this2.arn}/*"]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}