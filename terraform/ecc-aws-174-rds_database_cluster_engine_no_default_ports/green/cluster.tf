resource "aws_rds_cluster" "default" {
  cluster_identifier  = "cluster-174-green"
  engine              = "aurora-mysql"
  engine_version      = "5.7.mysql_aurora.2.03.2"
  database_name       = "cluster174green"
  master_username     = "root"
  master_password     = random_password.this.result
  skip_final_snapshot = true
  port                = 6033
}

resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}