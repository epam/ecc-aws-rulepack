# Time to deploy about 7 min

resource "aws_redshift_cluster" "this1" {
  cluster_identifier                   = "${module.naming.resource_prefix.redshift_cluster}-1"
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
  cluster_parameter_group_name         = aws_redshift_parameter_group.this1.name
  availability_zone_relocation_enabled = true
}

resource "aws_redshift_logging" "this1" {
  cluster_identifier   = aws_redshift_cluster.this1.id
  log_destination_type = "s3"
  bucket_name          = aws_s3_bucket.this.id
}

resource "aws_redshift_cluster" "this2" {
  cluster_identifier           = "${module.naming.resource_prefix.redshift_cluster}-2"
  database_name                = "redshifttest"
  master_username              = "root"
  master_password              = random_password.this.result
  node_type                    = "dc2.large"
  port                         = 5431
  skip_final_snapshot          = true
  allow_version_upgrade        = true
  publicly_accessible          = false
  cluster_parameter_group_name = aws_redshift_parameter_group.this2.name
}

resource "aws_redshift_logging" "this2" {
  cluster_identifier   = aws_redshift_cluster.this2.id
  log_destination_type = "cloudwatch"
  log_exports          = ["connectionlog", "userlog", "useractivitylog"]

  depends_on = [aws_cloudwatch_log_group.this]
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/redshift/cluster/${aws_redshift_cluster.this2.id}"
}

resource "aws_redshift_parameter_group" "this1" {
  name   = "${module.naming.resource_prefix.redshift_parameter_group}-1"
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

resource "aws_redshift_parameter_group" "this2" {
  name   = "${module.naming.resource_prefix.redshift_parameter_group}-2"
  family = "redshift-1.0"

  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  min_numeric      = 1
  min_special      = 1
  override_special = "!#$%*()-_=+[]{}:?"
}


