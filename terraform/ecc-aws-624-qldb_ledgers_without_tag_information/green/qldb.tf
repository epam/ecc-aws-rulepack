resource "aws_qldb_ledger" "this" {
  name                = "qldb-624-green"
  permissions_mode    = "STANDARD"
  deletion_protection = false
}
