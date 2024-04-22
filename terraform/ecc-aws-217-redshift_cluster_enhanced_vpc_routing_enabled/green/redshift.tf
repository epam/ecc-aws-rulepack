resource "aws_redshift_cluster" "this" {
  cluster_identifier   = "c7n-217-redshift-green"
  database_name        = "c7nredshiftgreen"
  master_username      = "root"
  master_password      = random_password.this.result
  node_type            = "dc2.large"
  skip_final_snapshot  = true
  enhanced_vpc_routing = true
}

resource "random_password" "this" {
  length           = 12
  min_numeric      = 1
}
