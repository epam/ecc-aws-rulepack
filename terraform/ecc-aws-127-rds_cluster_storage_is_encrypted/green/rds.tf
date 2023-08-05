resource "aws_rds_cluster" "this" {
  cluster_identifier  = "rds-127-green"
  engine              = "aurora-mysql"
  engine_version      = "5.7.mysql_aurora.2.03.2"
  database_name       = "rdsgreen"
  master_username     = "root"
  master_password     = random_password.this.result
  skip_final_snapshot = true
  storage_encrypted   = true
  kms_key_id          = aws_kms_key.this.arn
}

resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_kms_key" "this" {
  description             = "127_kms_key_green"
  deletion_window_in_days = 10
}
