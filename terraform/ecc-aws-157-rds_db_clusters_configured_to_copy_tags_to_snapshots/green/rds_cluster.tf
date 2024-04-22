resource "aws_rds_cluster" "this" {
  cluster_identifier    = "cluster-157-green"
  engine                = "aurora-mysql"
  engine_version        = "5.7.mysql_aurora.2.12.1"
  database_name         = "cluster157green"
  master_username       = "root"
  master_password       = random_password.this.result
  skip_final_snapshot   = true
  copy_tags_to_snapshot = true
}

resource "aws_db_cluster_snapshot" "this" {
  db_cluster_identifier          = aws_rds_cluster.this.id
  db_cluster_snapshot_identifier = "db-cluster-snapshot-157-green"

  depends_on = [aws_rds_cluster.this]
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}