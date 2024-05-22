resource "aws_qldb_ledger" "this" {
  name                = "${module.naming.resource_prefix.qldb}"
  permissions_mode    = "ALLOW_ALL"
  deletion_protection = false
  provider            = aws.provider2
}
