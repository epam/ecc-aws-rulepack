resource "aws_s3_bucket" "this" {
  bucket = "069-bucket-${random_integer.this.result}-red"
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json

  depends_on = [aws_s3_bucket_public_access_block.this ]
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["*"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }
}

