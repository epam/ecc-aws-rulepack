resource "aws_rds_cluster" "this" {
  cluster_identifier  = "cluster-771-red"
  engine              = "aurora-mysql"
  engine_version      = "5.7.mysql_aurora.2.10.2"
  database_name       = "cluster771red"
  master_username     = "admin"
  master_password     = random_password.this.result
  skip_final_snapshot = true
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}