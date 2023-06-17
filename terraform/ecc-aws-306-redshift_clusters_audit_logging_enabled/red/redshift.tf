resource "aws_redshift_cluster" "this" {
  cluster_identifier           = "redshift-306-red"
  database_name                = "redshift306red"
  master_username              = "root"
  master_password              = random_password.this.result
  node_type                    = "dc2.large"
  skip_final_snapshot          = true
  cluster_parameter_group_name = aws_redshift_parameter_group.this.name
}

resource "aws_redshift_parameter_group" "this" {
  name   = "parameter-group-306-red"
  family = "redshift-1.0"

  parameter {
    name  = "enable_user_activity_logging"
    value = "false"
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  min_numeric      = 1
  override_special = "!#$%*()-_=+[]{}:?"
}