resource "aws_iam_role" "firehose_role" {
  name = "${module.naming.resource_prefix.firehose}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_iam" {
  name = "${module.naming.resource_prefix.lambda_function}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = "${module.naming.resource_prefix.firehose}"
  destination = "extended_s3"
  server_side_encryption{
    enabled = true
  }
  extended_s3_configuration{
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.this.arn
  }
}

resource "aws_s3_bucket" "this" {
  bucket = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}"
  force_destroy = "true"
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
