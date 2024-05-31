resource "aws_qldb_ledger" "this" {
  name                = module.naming.resource_prefix.qldb
  permissions_mode    = "STANDARD"
  deletion_protection = true
}

resource "null_resource" "this" {
  triggers = {
    qldb = aws_qldb_ledger.this.id
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws qldb update-ledger --name ${self.triggers.qldb} --no-deletion-protection"
  }

  depends_on = [aws_qldb_ledger.this]
}