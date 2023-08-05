resource "random_integer" "this" {
  min = 1
  max = 10000000
}

data "aws_caller_identity" "this" {}

resource "aws_s3_bucket" "this" {
  bucket = "543-bucket-${random_integer.this.result}-red"

  force_destroy = true
}

resource "aws_s3_object" "this" {
  bucket       = aws_s3_bucket.this.id
  key          = "/index.html"
  source       = "index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}
