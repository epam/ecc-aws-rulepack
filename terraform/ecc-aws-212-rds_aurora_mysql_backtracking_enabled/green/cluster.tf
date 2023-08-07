resource "aws_rds_cluster" "this" {
  cluster_identifier  = "cluster-212-green"
  engine              = "aurora-mysql"
  engine_version      = "5.7.mysql_aurora.2.07.2"
  database_name       = "cluster212green"
  master_username     = "root"
  master_password     = random_password.this.result
  skip_final_snapshot = true
  backtrack_window    = 600

}

resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}