resource "aws_redshift_cluster" "this" {
  cluster_identifier  = "redshift-087-green"
  database_name       = "redshift087green"
  master_username     = "root"
  master_password     = random_password.this.result
  node_type           = "dc2.large"
  publicly_accessible = false
  skip_final_snapshot = true
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}