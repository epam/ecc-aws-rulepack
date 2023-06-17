resource "aws_redshift_cluster" "this" {
  cluster_identifier  = "redshift-517-red"
  database_name       = "redshift_517_red_db"
  master_username     = "root"
  master_password     = random_password.this.result
  node_type           = "dc2.large"
  skip_final_snapshot = true
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}
