resource "aws_s3_bucket" "this3" {
  bucket        = "004-bucket-${random_integer.this.result}-green-3"
  force_destroy = true
}


resource "aws_s3_bucket_policy" "this3" {
  bucket = aws_s3_bucket.this3.id
  policy = data.aws_iam_policy_document.this3.json
}

data "aws_iam_policy_document" "this3" {
  statement {
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["*"]
    resources = ["${aws_s3_bucket.this3.arn}/*"]
    condition {
      test     = "NumericLessThan"
      variable = "s3:TlsVersion"

      values = [
        "1.2"
      ]
    }
  }
}