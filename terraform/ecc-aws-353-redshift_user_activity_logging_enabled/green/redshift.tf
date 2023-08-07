resource "aws_redshift_cluster" "this" {
  cluster_identifier           = "redshift-353-green"
  database_name                = "redshift_353_green_db"
  master_username              = "root"
  master_password              = random_password.this.result
  node_type                    = "dc2.large"
  skip_final_snapshot          = true
  cluster_parameter_group_name = aws_redshift_parameter_group.this.name

  logging {
    enable               = true
    log_destination_type = "cloudwatch"
    log_exports          = ["useractivitylog"]
  }
}

resource "aws_redshift_parameter_group" "this" {
  name   = "parameter-group-redshift-353-green"
  family = "redshift-1.0"

  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

