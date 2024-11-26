resource "aws_s3_bucket" "this1" {
  bucket        = "004-bucket-${random_integer.this.result}-green-1"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}


resource "aws_s3_bucket_policy" "this1" {
  bucket = aws_s3_bucket.this1.id
  policy = data.aws_iam_policy_document.this1.json
}

data "aws_iam_policy_document" "this1" {
  statement {
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.this1.arn}/*"]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}