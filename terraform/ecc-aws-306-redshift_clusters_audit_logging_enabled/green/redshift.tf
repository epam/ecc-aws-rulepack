data "aws_caller_identity" "current" {}

resource "aws_redshift_cluster" "this" {
  cluster_identifier           = "redshift-306-green"
  database_name                = "redshift306green"
  master_username              = "root"
  master_password              = random_password.this.result
  node_type                    = "dc2.large"
  skip_final_snapshot          = true
  cluster_parameter_group_name = aws_redshift_parameter_group.this.name

  logging {
    enable      = true
    bucket_name = aws_s3_bucket.this.id
  }
}

resource "aws_redshift_parameter_group" "this" {
  name   = "parameter-group-306-green"
  family = "redshift-1.0"

  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }
}
resource "aws_s3_bucket" "this" {
  bucket        = "bucket-306-green"
  force_destroy = "true"
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
    sid    = "Put bucket policy needed for audit logging"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::bucket-306-green/*"]
  }
  statement {
    sid    = "Get bucket policy needed for audit logging "
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::bucket-306-green"]
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  min_numeric      = 1
  override_special = "!#$%*()-_=+[]{}:?"
}
