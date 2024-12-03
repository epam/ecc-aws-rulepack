data "aws_caller_identity" "current" {}

resource "aws_redshift_cluster" "this" {
  cluster_identifier           = "redshift-353-red3"
  database_name                = "redshift353red"
  master_username              = "root"
  master_password              = random_password.this.result
  node_type                    = "dc2.large"
  skip_final_snapshot          = true
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
