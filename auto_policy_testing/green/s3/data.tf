data "aws_availability_zones" "this" {
  state = "available"
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}

data "aws_caller_identity" "this" {}