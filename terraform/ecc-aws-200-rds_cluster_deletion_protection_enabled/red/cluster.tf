resource "aws_rds_cluster" "this" {
  cluster_identifier  = "cluster-200-red"
  engine              = "aurora-mysql"
  engine_version      = "5.7.mysql_aurora.2.03.2"
  database_name       = "cluster200red"
  master_username     = "root"
  master_password     = random_password.this.result
  skip_final_snapshot = true
}

resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}