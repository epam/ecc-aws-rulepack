resource "aws_s3_bucket" "this" {
  bucket        = "www.510-domain-green.click"
  force_destroy = "true"
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.this.bucket
  key          = "index.html"
  source       = "index.html"
  etag         = filemd5("index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.this.bucket
  key          = "error.html"
  source       = "error.html"
  etag         = filemd5("error.html")
  content_type = "text/html"
}

data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["*"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}