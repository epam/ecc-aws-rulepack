resource "aws_qldb_ledger" "this" {
  name                = "qldb-439-green"
  permissions_mode    = "STANDARD"
  deletion_protection = true
}
