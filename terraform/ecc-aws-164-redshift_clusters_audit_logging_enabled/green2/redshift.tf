data "aws_caller_identity" "current" {}

resource "aws_redshift_cluster" "this" {
  cluster_identifier           = "redshift-164-green2"
  database_name                = "redshift164green"
  master_username              = "root"
  master_password              = random_password.this.result
  node_type                    = "dc2.large"
  skip_final_snapshot          = true
  cluster_parameter_group_name = aws_redshift_parameter_group.this.name
}

resource "aws_cloudwatch_log_group" "useractivitylog" {
  name = "/aws/redshift/cluster/${aws_redshift_cluster.this.cluster_identifier}/useractivitylog"
}
resource "aws_cloudwatch_log_group" "userlog" {
  name = "/aws/redshift/cluster/${aws_redshift_cluster.this.cluster_identifier}/userlog"
}
resource "aws_cloudwatch_log_group" "connectionlog" {
  name = "/aws/redshift/cluster/${aws_redshift_cluster.this.cluster_identifier}/connectionlog"
}

resource "aws_redshift_logging" "this" {
  cluster_identifier   = aws_redshift_cluster.this.id
  log_destination_type = "cloudwatch"
  log_exports          = ["connectionlog", "userlog", "useractivitylog"]
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}

resource "aws_redshift_parameter_group" "this" {
  name   = "parameter-group-164-green2"
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
  min_upper        = 1
  min_lower        = 1
  override_special = "!#$%*()-_=+[]{}:?"
}
