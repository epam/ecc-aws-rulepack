resource "random_password" "this" {
  length           = 12
  lower            = true
  min_lower        = 1
  upper            = true
  min_upper        = 1
  special          = true
  min_special      = 1
  numeric          = true
  min_numeric      = 1
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_rds_cluster" "this" {
  cluster_identifier        = "cluster-873-red"
  engine                    = "mysql"
  db_cluster_instance_class = "db.c6gd.large"
  storage_type              = "gp3"
  allocated_storage         = 20
  master_username           = "root"
  master_password           = random_password.this.result
  skip_final_snapshot       = true
  engine_lifecycle_support  = "open-source-rds-extended-support-disabled"
}
