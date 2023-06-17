resource "aws_rds_cluster" "this" {
  cluster_identifier  = "cluster-299-red"
  engine              = "aurora-mysql"
  engine_version      = "5.7.mysql_aurora.2.03.2"
  database_name       = "cluster299red"
  master_username     = "root"
  master_password     = random_password.this.result
  skip_final_snapshot = true
}

resource "aws_db_cluster_snapshot" "this" {
  db_cluster_identifier          = aws_rds_cluster.this.id
  db_cluster_snapshot_identifier = "db-cluster-snapshot-299-red"

  depends_on = [aws_rds_cluster.this]
}

resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}