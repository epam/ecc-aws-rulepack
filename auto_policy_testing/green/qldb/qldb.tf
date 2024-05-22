resource "aws_qldb_ledger" "this" {
  name                = "${module.naming.resource_prefix.qldb}"
  permissions_mode    = "STANDARD"
  # deletion_protection = true
}
