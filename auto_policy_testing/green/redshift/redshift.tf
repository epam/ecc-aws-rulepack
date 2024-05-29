resource "aws_redshift_cluster" "this" {
  cluster_identifier                   = "${module.naming.resource_prefix.redshift_cluster}"
  database_name                        = "redshifttest"
  master_username                      = "root"
  master_password                      = random_password.this.result
  node_type                            = "ra3.xlplus"
  port                                 = 5431
  skip_final_snapshot                  = true
  automated_snapshot_retention_period  = 7
  encrypted                            = true
  kms_key_id                           = data.terraform_remote_state.common.outputs.kms_key_arn
  allow_version_upgrade                = true
  publicly_accessible                  = false
  enhanced_vpc_routing                 = true
  cluster_parameter_group_name         = aws_redshift_parameter_group.this.name
  availability_zone_relocation_enabled = true

  logging {
    enable      = true
    bucket_name = aws_s3_bucket.this.id
  }

  depends_on = [
    aws_s3_bucket_acl.this
  ]
}

resource "aws_redshift_parameter_group" "this" {
  name   = "${module.naming.resource_prefix.redshift_parameter_group}"
  family = "redshift-1.0"

  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }

  parameter {
    name  = "require_ssl"
    value = "true"
  }
}

resource "aws_s3_bucket" "this" {
  bucket        = "${module.naming.resource_prefix.redshift_cluster}-${random_integer.this.result}"
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

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  min_numeric      = 1
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

