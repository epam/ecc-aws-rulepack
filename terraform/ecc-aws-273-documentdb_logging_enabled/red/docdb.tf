resource "aws_docdb_cluster" "this" {
  cluster_identifier              = "cluster-273-red"
  engine                          = "docdb"
  master_username                 = "root"
  master_password                 = random_password.this.result
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["audit"]
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.this.id
}

resource "aws_docdb_cluster_instance" "this" {
  count              = 1
  identifier         = "docdb-273-red-${count.index}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = "db.t3.medium"
}

resource "aws_docdb_cluster_parameter_group" "this" {
  name   = "parameter-group-273-red"
  family = "docdb5.0"
}


resource "random_password" "this" {
  length  = 12
  special = true
  override_special = "!#$%*()-_=+[]{}:?"
}
