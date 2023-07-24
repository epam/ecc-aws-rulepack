resource "aws_s3_bucket" "this" {
  bucket = "339-bucket-${random_integer.this.result}-green"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_elb_service_account" "this" {}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.this.arn]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this.arn}/AWSLogs/*"]
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

  depends_on = [
    aws_s3_bucket_acl.this
  ]
}
