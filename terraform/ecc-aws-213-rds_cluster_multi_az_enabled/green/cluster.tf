resource "aws_rds_cluster" "this" {
  cluster_identifier  = "cluster-213-green"
  engine              = "aurora-mysql"
  engine_version      = "5.7.mysql_aurora.2.12.1"
  database_name       = "cluster213green"
  master_username     = "root"
  master_password     = random_password.this.result
  skip_final_snapshot = true

}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_rds_cluster_instance" "instance1" {
  identifier         = "rds-cluster-instance1-213-green"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.t2.small"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  availability_zone  = "us-east-1d"
  depends_on = [
    aws_rds_cluster.this
  ]
}

resource "aws_rds_cluster_instance" "instance2" {
  identifier         = "rds-cluster-instance2-213-green"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.t2.small"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  availability_zone  = "us-east-1c"

  depends_on = [
    aws_rds_cluster.this
  ]
}