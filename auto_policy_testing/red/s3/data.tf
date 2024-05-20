data "aws_availability_zones" "this" {
  state = "available"
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["*"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }
}

data "aws_caller_identity" "this" {}

data "aws_canonical_user_id" "current" {}