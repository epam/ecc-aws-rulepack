data "aws_caller_identity" "this" {}

resource "aws_cloudtrail" "this" {
  name                       = "cloudtrail-055-green"
  s3_bucket_name             = aws_s3_bucket.this.id
  cloud_watch_logs_role_arn  = aws_iam_role.this.arn
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.this.arn}:*"
}

resource "aws_s3_bucket" "this" {
  bucket        = "055-bucket-${random_integer.this.result}-green"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.this.arn]
  }

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this.arn}/AWSLogs/${data.aws_caller_identity.this.account_id}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      
      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "055_log_group_green"
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "055_log_stream_green"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_iam_role" "this" {
  name               = "055_cloudwatch_role_green"
  assume_role_policy = <<-POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
    POLICY
}

resource "aws_iam_role_policy" "this" {
  name   = "055_policy_green"
  role   = aws_iam_role.this.id
  policy = <<-POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AWSCloudTrailCreateLogStream2014110",
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream"
        ],
        "Resource": [
          "arn:aws:logs:${var.default-region}:${data.aws_caller_identity.this.account_id}:log-group:${aws_cloudwatch_log_group.this.name}:log-stream:*"
        ]
      },
      {
        "Sid": "AWSCloudTrailPutLogEvents20141101",
        "Effect": "Allow",
        "Action": [
          "logs:PutLogEvents"
        ],
        "Resource": [
          "arn:aws:logs:${var.default-region}:${data.aws_caller_identity.this.account_id}:log-group:${aws_cloudwatch_log_group.this.name}:log-stream:*"
        ]
      }
    ]
  }
  POLICY
}