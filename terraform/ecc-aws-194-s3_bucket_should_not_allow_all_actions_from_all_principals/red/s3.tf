resource "aws_s3_bucket" "this" {
  bucket = "bucket-194-red"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["*"]
    resources = ["arn:aws:s3:::bucket-194-red/*"]
  }
}

