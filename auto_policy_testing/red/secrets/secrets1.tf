resource "aws_secretsmanager_secret" "this1" {
  name                    = "${module.naming.resource_prefix.secrets}-1"
  recovery_window_in_days = 0
}