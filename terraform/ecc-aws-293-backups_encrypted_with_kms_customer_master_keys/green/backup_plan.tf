resource "aws_backup_vault" "this" {
  name        = "293_backup_vault_green"
  kms_key_arn = aws_kms_key.this.arn
}

resource "aws_kms_key" "this" {
  description             = "242_kms_key_green"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "this" {
  name          = "alias/293_kms_alias_green"
  target_key_id = aws_kms_key.this.key_id
}