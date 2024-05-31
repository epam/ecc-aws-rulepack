resource "aws_qldb_ledger" "this" {
  provider            = aws.provider2
  name                = "${module.naming.resource_prefix.qldb}"
  permissions_mode    = "ALLOW_ALL"
  deletion_protection = false
}
