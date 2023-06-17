resource "aws_redshift_cluster" "this" {
  cluster_identifier    = "c7n-363-redshift-red"
  database_name         = "c7nredshiftred"
  master_username       = "root"
  master_password       = random_password.this.result
  node_type             = "dc2.large"
  skip_final_snapshot   = true
  allow_version_upgrade = false
}

resource "random_password" "this" {
  length      = 10
  special     = true
  min_numeric = 1
}
