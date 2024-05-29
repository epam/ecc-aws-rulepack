resource "aws_redshift_cluster" "this" {
  cluster_identifier                   = "${module.naming.resource_prefix.redshift_cluster}"
  database_name                        = "dev"
  master_username                      = "awsuser"
  master_password                      = random_password.this.result
  node_type                            = "dc2.large"
  skip_final_snapshot                  = true
  encrypted                            = false
  allow_version_upgrade                = false
  enhanced_vpc_routing                 = false
  availability_zone_relocation_enabled = false 
  provider                             = aws.provider2
  cluster_parameter_group_name         = aws_redshift_parameter_group.this.name
}

resource "aws_redshift_parameter_group" "this" {
  name   = "${module.naming.resource_prefix.redshift_parameter_group}"
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
  override_special = "!#$%*()-_=+[]{}:?"
}
