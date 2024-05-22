output "gldb" {
  value = {
    qldb = aws_qldb_ledger.this.arn
  }
}
