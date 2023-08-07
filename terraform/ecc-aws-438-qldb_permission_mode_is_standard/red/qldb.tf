resource "aws_qldb_ledger" "this" {
  name                = "qldb-438-red"
  permissions_mode    = "ALLOW_ALL"
}