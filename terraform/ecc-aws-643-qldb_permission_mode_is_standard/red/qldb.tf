resource "aws_qldb_ledger" "this" {
  name                = "qldb-643-red"
  permissions_mode    = "ALLOW_ALL"
}