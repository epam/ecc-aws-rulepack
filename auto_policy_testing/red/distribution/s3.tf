resource "random_integer" "this" {
  min = 10000
  max = 99999
}

data "aws_caller_identity" "this" {}

resource "aws_s3_bucket" "this" {
  bucket = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}-1"

  force_destroy = true
}

resource "aws_s3_object" "this" {
  bucket       = aws_s3_bucket.this.id
  key          = "/index.html"
  source       = "index.html"
  content_type = "text/html"
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
      values   = [aws_cloudfront_distribution.this1.arn, aws_cloudfront_distribution.this2.arn]
    }
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = "index.html"
  }
}