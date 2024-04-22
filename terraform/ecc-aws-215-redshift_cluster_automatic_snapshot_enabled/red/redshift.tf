resource "aws_redshift_cluster" "this" {
  cluster_identifier  = "c7n-215-redshift-red"
  database_name       = "c7nredshiftred"
  master_username     = "root"
  master_password     = random_password.this.result
  node_type           = "dc2.large"
  skip_final_snapshot = true
}

resource "random_password" "this" {
  length           = 12
  special          = false
  min_numeric      = 1
}
