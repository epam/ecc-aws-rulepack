resource "aws_backup_vault" "this" {
  name = "291_backup_vault_green"
}

resource "aws_backup_plan" "this" {
  name = "291_backup_plan_green"

  rule {
    rule_name         = "291_backup_rule_green"
    target_vault_name = aws_backup_vault.this.name
    schedule          = "cron(0 12 * * ? *)"

    lifecycle {
      cold_storage_after = 90
      delete_after       = 180
    }
  }
}