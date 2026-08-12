resource "aws_iam_role" "this" {
  name                 = module.naming.resource_prefix.glue_job
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:policy/eo_role_boundary"
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "this" {
  name = module.naming.resource_prefix.glue_job
  role = aws_iam_role.this.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}


resource "aws_s3_object" "this" {
  bucket = aws_s3_bucket.this.id
  key    = "script"
  acl    = "private"
  source = "script.py"
  etag   = filemd5("script.py")
}

resource "aws_s3_bucket" "this" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}"
  force_destroy = true
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

resource "aws_cloudwatch_log_group" "this" {
  name = module.naming.resource_prefix.glue_job
}

resource "aws_glue_job" "this" {
  name         = module.naming.resource_prefix.glue_job
  role_arn     = aws_iam_role.this.arn
  glue_version = "4.0"
  default_arguments = {
    "--continuous-log-logGroup"          = aws_cloudwatch_log_group.this.name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
    "--enable-spark-ui"                  = "true"
    "--enable-auto-scaling"              = "true"
  }
  command {
    script_location = "s3://${aws_s3_bucket.this.bucket}/script"
  }
}
