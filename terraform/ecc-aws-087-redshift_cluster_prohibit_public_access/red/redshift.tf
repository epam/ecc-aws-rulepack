resource "aws_redshift_cluster" "this" {
  cluster_identifier  = "redshift-087-red"
  database_name       = "redshift087red"
  master_username     = "root"
  master_password     = random_password.this.result
  node_type           = "dc2.large"
  skip_final_snapshot = true
}

resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}