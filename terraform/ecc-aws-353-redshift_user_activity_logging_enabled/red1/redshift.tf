data "aws_caller_identity" "current" {}

resource "aws_redshift_cluster" "this" {
  cluster_identifier           = "redshift-353-red"
  database_name                = "redshift353red"
  master_username              = "root"
  master_password              = random_password.this.result
  node_type                    = "dc2.large"
  skip_final_snapshot          = true
  cluster_parameter_group_name = aws_redshift_parameter_group.this.name
}

resource "aws_redshift_logging" "this" {
  cluster_identifier   = aws_redshift_cluster.this.id
  log_destination_type = "s3"
  bucket_name          = aws_s3_bucket.this.id
  s3_key_prefix        = "/"

  depends_on = [
    aws_s3_bucket_policy.this
  ]
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}

resource "aws_redshift_parameter_group" "this" {
  name   = "parameter-group-353-red"
  family = "redshift-1.0"

  parameter {
    name  = "enable_user_activity_logging"
    value = "false"
  }
}

resource "aws_s3_bucket" "this" {
  bucket        = "353-bucket-${random_integer.this.result}-red"
  force_destroy = "true"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {

  statement {
    sid    = "Put bucket policy needed for audit logging"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }
  statement {
    sid    = "Get bucket policy needed for audit logging "
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.this.arn]
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  min_numeric      = 1
  min_upper        = 1
  min_lower        = 1
  override_special = "!#$%*()-_=+[]{}:?"
}
