resource "aws_redshift_cluster" "this" {
  cluster_identifier  = "redshift-215-green"
  database_name       = "redshift215green"
  master_username     = "root"
  master_password     = random_password.this.result
  node_type           = "dc2.large"
  publicly_accessible = false
  skip_final_snapshot = true
}

resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}