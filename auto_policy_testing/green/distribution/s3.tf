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

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["s3:GetObject", "s3:PutBucketACL"]
    resources = ["${aws_s3_bucket.this.arn}/*", "${aws_s3_bucket.this.arn}"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
  }
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

resource "aws_s3_bucket" "this2" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}-failover"
  force_destroy = true
}
