resource "aws_redshift_cluster" "this" {
  cluster_identifier           = "c7n-429-redshift-red"
  database_name                = "redshiftred"
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
  override_special = "!#$%*()-_=+[]{}:?"
}
