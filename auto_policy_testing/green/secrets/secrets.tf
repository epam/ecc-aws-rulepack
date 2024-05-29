resource "aws_iam_role" "this" {
  name = "${module.naming.resource_prefix.secrets}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "this1" {
  name   = "${module.naming.resource_prefix.secrets}-1"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this1.json
}

resource "aws_iam_role_policy" "this2" {
  name   = "${module.naming.resource_prefix.secrets}-2"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this2.json
}

resource "aws_iam_role_policy" "this3" {
  name   = "${module.naming.resource_prefix.secrets}-3"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this3.json
}

resource "aws_iam_role_policy" "this4" {
  name   = "${module.naming.resource_prefix.secrets}-4"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this4.json
}

resource "aws_iam_role_policy_attachment" "this1" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "this2" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "this" {
  filename         = "lambda_function.zip"
  function_name    = "${module.naming.resource_prefix.secrets}"
  role             = aws_iam_role.this.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.12"

  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.us-east-1.amazonaws.com"
      EXCLUDE_CHRACTERS        = "/@\"'\\ "
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.this1.id, aws_subnet.this2.id]
    security_group_ids = [aws_security_group.this.id]
  }

}

resource "aws_lambda_permission" "this" {
  function_name = aws_lambda_function.this.function_name
  statement_id  = "AllowExecutionSecretManager"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com"
}

resource "aws_db_subnet_group" "this" {
  name       = "${module.naming.resource_prefix.secrets}"
  subnet_ids = [aws_subnet.this1.id, aws_subnet.this2.id]
}

resource "aws_db_instance" "this" {
  identifier             = "${module.naming.resource_prefix.secrets}"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  storage_type           = "gp2"
  db_name                = "databasegreen"
  username               = "adminaccount"
  password               = random_password.this.result
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  publicly_accessible    = true
}

resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_secretsmanager_secret" "this" {
  name = "${module.naming.resource_prefix.secrets}"

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

resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

}

resource "aws_subnet" "this1" {
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "this2" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this1.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "this2" {
  subnet_id      = aws_subnet.this2.id
  route_table_id = aws_route_table.this.id
}

resource "aws_security_group" "this" {
  name   = "${module.naming.resource_prefix.secrets}"
  vpc_id = aws_vpc.this.id

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
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [aws_subnet.this1.id, aws_subnet.this2.id]
  security_group_ids = [
    aws_security_group.this.id,
  ]
}

