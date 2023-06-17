resource "aws_s3_bucket" "this" {
  bucket        = "101-bucket-green"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
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

    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::101-bucket-green/*"] 
  }
}
