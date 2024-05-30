# Time to deploy about 7 min

resource "aws_redshift_cluster" "this" {
  provider                             = aws.provider2
  cluster_identifier                   = "${module.naming.resource_prefix.redshift_cluster}2"
  master_username                      = "awsuser"
  database_name                        = "dev"
  master_password                      = random_password.this.result
  node_type                            = "dc2.large"
  skip_final_snapshot                  = true
  automated_snapshot_retention_period  = 0
  encrypted                            = false
  allow_version_upgrade                = false
  enhanced_vpc_routing                 = false
  availability_zone_relocation_enabled = false
  publicly_accessible                  = true
  cluster_parameter_group_name         = aws_redshift_parameter_group.this.name
}

resource "aws_redshift_parameter_group" "this" {
  name   = "${module.naming.resource_prefix.redshift_parameter_group}-2"
  family = "redshift-1.0"

  parameter {
    name  = "enable_user_activity_logging"
    value = "false"
  }

  parameter {
    name  = "require_ssl"
    value = "false"
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  min_numeric      = 1
  min_special      = 1
  override_special = "!#$%*()-_=+[]{}:?"
}
