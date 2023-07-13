resource "aws_s3_bucket" "this" {
  bucket = "bucket1-194-green"
}

resource "aws_s3_bucket" "this1" {
  bucket = "bucket2-194-green"
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["*"]
    resources = ["arn:aws:s3:::bucket1-194-green/*"]
  }
}

data "aws_iam_policy_document" "this1" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::bucket2-194-green/*"]
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_s3_bucket_policy" "this1" {
  bucket = aws_s3_bucket.this1.id
  policy = data.aws_iam_policy_document.this1.json
}