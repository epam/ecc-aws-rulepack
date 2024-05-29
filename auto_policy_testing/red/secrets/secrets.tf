resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_secretsmanager_secret" "this" {
  name = "${module.naming.resource_prefix.secrets}"
}