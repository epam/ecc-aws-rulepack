data "aws_caller_identity" "current" {}

resource "aws_redshift_cluster" "this" {
  cluster_identifier           = "redshift-164-red2"
  database_name                = "redshift164red"
  master_username              = "root"
  master_password              = random_password.this.result
  node_type                    = "dc2.large"
  skip_final_snapshot          = true
}

resource "aws_cloudwatch_log_group" "useractivitylog" {
  name = "/aws/redshift/cluster/${aws_redshift_cluster.this.cluster_identifier}/useractivitylog"
}
resource "aws_cloudwatch_log_group" "userlog" {
  name = "/aws/redshift/cluster/${aws_redshift_cluster.this.cluster_identifier}/userlog"
}


resource "aws_redshift_logging" "this" {
  cluster_identifier   = aws_redshift_cluster.this.id
  log_destination_type = "cloudwatch"
  log_exports          = ["userlog", "useractivitylog"]
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
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
