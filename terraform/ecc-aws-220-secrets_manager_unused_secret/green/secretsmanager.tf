resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_secretsmanager_secret" "this" {
  name = "220_secret_green"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = <<EOF
   {
    "username": "adminaccount",
    "password": "${random_password.this.result}"
   }
EOF
}

data "aws_secretsmanager_secret" "this" {
  arn = aws_secretsmanager_secret.this.arn
}

data "aws_secretsmanager_secret_version" "this" {
  secret_id = data.aws_secretsmanager_secret.this.id

  depends_on = [data.aws_secretsmanager_secret_version.this]
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.this.secret_string
  )
}