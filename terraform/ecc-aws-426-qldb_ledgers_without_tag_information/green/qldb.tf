resource "aws_qldb_ledger" "this" {
  name                = "qldb-426-green"
  permissions_mode    = "STANDARD"
  deletion_protection = false
}
