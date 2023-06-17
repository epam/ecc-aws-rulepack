resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt RDS"
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.this.json
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true

}

resource "aws_kms_alias" "this" {
  name          = "alias/515-green"
  target_key_id = aws_kms_key.this.key_id
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "*",
      ]
    }
    actions = [
      "kms:*",
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_db_instance" "this" {
  allocated_storage     = 10
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t3.micro"
  db_name               = "database515green"
  username              = "root"
  password              = random_password.this.result
  parameter_group_name  = "default.mysql5.7"
  skip_final_snapshot   = true
  storage_encrypted     = true
  kms_key_id            = aws_kms_key.this.arn
}
