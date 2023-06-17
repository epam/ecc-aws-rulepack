resource "aws_rds_cluster" "this" {
  cluster_identifier  = "rds-cluster-360-red"
  engine              = "aurora-mysql"
  engine_version      = "5.7.mysql_aurora.2.03.2"
  database_name       = "cluster360red"
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

resource "aws_rds_cluster_instance" "this" {
  identifier         = "rds-cluster-instance-360-red"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.t2.small"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  depends_on = [
    aws_rds_cluster.this
  ]
}