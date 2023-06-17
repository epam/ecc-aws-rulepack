resource "aws_redshift_cluster" "this" {
  cluster_identifier    = "c7n-363-redshift-green"
  database_name         = "c7nredshiftgreen"
  master_username       = "root"
  master_password       = random_password.this.result
  node_type             = "dc2.large"
  skip_final_snapshot   = true
  allow_version_upgrade = true
}

resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "_%@"
}
