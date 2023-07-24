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
  depends_on = [
    aws_s3_bucket_acl.this
  ]
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
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
  bucket        = "306-bucket-${random_integer.this.result}-green"
  force_destroy = "true"
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

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
  override_special = "!#$%*()-_=+[]{}:?"
}
