resource "aws_redshift_cluster" "this" {
  cluster_identifier                   = "c7n-449-redshift-green"
  database_name                        = "c7nredshiftgreen"
  master_username                      = "root"
  master_password                      = random_password.this.result
  node_type                            = "ra3.xlplus"
  skip_final_snapshot                  = true
  availability_zone_relocation_enabled = true
  publicly_accessible                  = false
}

resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "_%@"
  min_numeric      = 1
}
