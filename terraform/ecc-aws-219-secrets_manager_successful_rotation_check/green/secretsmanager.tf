resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_secretsmanager_secret" "this" {
  name = "219_secret_greeen"

  depends_on = [aws_db_instance.this, aws_lambda_function.this]
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = <<EOF
   {
    "engine": "mysql",
    "host": "${aws_db_instance.this.address}",
    "username": "adminaccount",
    "password": "${random_password.this.result}",
    "dbname": "${aws_db_instance.this.db_name}",
    "port": "3306"
   }
EOF

  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
}

resource "aws_secretsmanager_secret_rotation" "this" {
  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = aws_lambda_function.this.arn

  rotation_rules {
    automatically_after_days = 7
  }
}