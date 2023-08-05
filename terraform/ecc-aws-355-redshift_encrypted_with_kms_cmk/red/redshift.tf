resource "aws_redshift_cluster" "this" {
  cluster_identifier  = "redshift-355-red"
  database_name       = "redshiftred"
  master_username     = "root"
  master_password     = random_password.this.result
  node_type           = "dc2.large"
  skip_final_snapshot = true
  encrypted = true
}

resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  lower            = true
  override_special = "!#$%*()-_=+[]{}:?"
}
