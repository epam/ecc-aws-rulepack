resource "aws_rds_cluster" "this" {
  cluster_identifier                  = "cluster-211-green"
  engine                              = "aurora-mysql"
  engine_version                      = "5.7.mysql_aurora.2.12.1"
  database_name                       = "cluster211green"
  master_username                     = "root"
  master_password                     = random_password.this.result
  skip_final_snapshot                 = true
  iam_database_authentication_enabled = true

}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}
