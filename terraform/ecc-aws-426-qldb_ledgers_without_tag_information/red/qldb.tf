resource "aws_qldb_ledger" "this" {
  name                = "qldb-426-red"
  permissions_mode    = "STANDARD"
  deletion_protection = false
}
