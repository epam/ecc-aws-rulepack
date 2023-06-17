resource "aws_redshift_cluster" "this" {
  cluster_identifier  = "c7n-776-redshift-red"
  database_name       = "redshift776green"
  master_username     = "awsuser"
  master_password     = random_password.this.result
  node_type           = "dc2.large"
  skip_final_snapshot = true
}

resource "random_password" "this" {
  length           = 12
  special          = false
  override_special = "_%@"
  min_numeric      = 1
}
