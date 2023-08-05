resource "aws_qldb_ledger" "this" {
  name                = "qldb-439-red"
  permissions_mode    = "STANDARD"
  deletion_protection = false
}