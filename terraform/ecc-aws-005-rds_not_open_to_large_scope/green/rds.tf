
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

resource "aws_db_instance" "this" {
  identifier               = "database-005-green"
  engine                   = "mysql"
  instance_class           = "db.t4g.micro"
  allocated_storage        = 20
  storage_type             = "gp2"
  username                 = "root"
  password                 = random_password.this.result
  skip_final_snapshot      = true
  backup_retention_period  = 0
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"
  vpc_security_group_ids   = ["${aws_security_group.this.id}"]
}