data "aws_caller_identity" "this" {}

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
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com", "logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    actions   = ["s3:PutObject",  "s3:GetBucketAcl"]
    resources = ["${aws_s3_bucket.this.arn}", "${aws_s3_bucket.this.arn}/AWSLogs/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        data.aws_caller_identity.this.account_id
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:logs:us-east-1:${data.aws_caller_identity.this.account_id}:*"
      ]
    }
  }
    
}



    