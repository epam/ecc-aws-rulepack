resource "aws_backup_vault" "this" {
  name = "440_backup_vault_red"
}

resource "aws_backup_plan" "this" {
  name = "440_backup_plan_red"

  rule {
    rule_name         = "440_backup_rule_red"
    target_vault_name = aws_backup_vault.this.name
    schedule          = "cron(0 12 * * ? *)"

    lifecycle {
      cold_storage_after = 365
    }
  }
}