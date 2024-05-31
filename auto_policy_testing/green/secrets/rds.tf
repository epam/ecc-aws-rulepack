resource "aws_db_instance" "this" {
  identifier             = "${module.naming.resource_prefix.rds_instance}"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  storage_type           = "gp2"
  username               = "adminaccount"
  password               = random_password.this.result
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.this.id]
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.this.name

}

resource "aws_db_subnet_group" "this" {
  name       = "${module.naming.resource_prefix.rds_instance}"
  subnet_ids = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_3_id]
}

resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}