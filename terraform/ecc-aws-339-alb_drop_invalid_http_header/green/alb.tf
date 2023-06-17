resource "aws_s3_bucket" "this" {
  bucket = "bucket-339-green"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::bucket-339-green/*"]
  }
}

resource "aws_alb" "this" {
  name                       = "alb-339-green"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.this.id]
  subnets                    = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  internal                   = true
  drop_invalid_header_fields = true
  access_logs {
    bucket  = aws_s3_bucket.this.id
    enabled = true
  }
}
