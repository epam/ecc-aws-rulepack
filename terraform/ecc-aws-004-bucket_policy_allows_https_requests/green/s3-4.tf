resource "aws_s3_bucket" "this4" {
  bucket        = "004-bucket-${random_integer.this.result}-green-4"
  force_destroy = true
}

resource "random_integer" "this4" {
  min = 1
  max = 10000000
}


resource "aws_s3_bucket_policy" "this4" {
  bucket = aws_s3_bucket.this4.id
  policy = data.aws_iam_policy_document.this4.json
}

data "aws_iam_policy_document" "this4" {
  statement {
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.this4.arn}/*"]
    condition {
      test     = "NumericLessThan"
      variable = "s3:TlsVersion"

      values = [
        "1.3"
      ]
    }
  }
}