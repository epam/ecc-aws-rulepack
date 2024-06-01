resource "aws_secretsmanager_secret" "this" {
  name                    = module.naming.resource_prefix.secrets
  recovery_window_in_days = 0

  depends_on = [aws_db_instance.this]
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
  rotate_immediately  = true
  rotation_rules {
    automatically_after_days = 90
  }
}


resource "aws_security_group" "this" {
  name   = module.naming.resource_prefix.security_group
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "this" {
  vpc_id              = data.terraform_remote_state.common.outputs.vpc_id
  service_name        = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = false

  subnet_ids = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_3_id]
  security_group_ids = [
    aws_security_group.this.id
  ]
}

resource "null_resource" "this" {

  provisioner "local-exec" {
    command = "sleep 5m"
  }

  depends_on = [aws_lambda_function.this, aws_db_instance.this, aws_secretsmanager_secret_rotation.this]
}