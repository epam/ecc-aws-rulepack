resource "aws_redshift_cluster" "this" {
  cluster_identifier           = "c7n-214-redshift-red"
  database_name                = "redshiftred"
  master_username              = "root"
  master_password              = random_password.this.result
  node_type                    = "dc2.large"
  skip_final_snapshot          = true
  cluster_parameter_group_name = aws_redshift_parameter_group.this.name
}

resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_redshift_parameter_group" "this" {
  name   = "parameter-group-214-red"
  family = "redshift-1.0"

  parameter {
    name  = "require_ssl"
    value = "false"
  }
}
