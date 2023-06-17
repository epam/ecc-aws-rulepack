resource "aws_redshift_cluster" "this" {
  cluster_identifier  = "redshift-520-green"
  database_name       = "redshiftgreen"
  master_username     = "root"
  master_password     = random_password.this.result
  node_type           = "dc2.large"
  skip_final_snapshot = true
  encrypted           = true
  kms_key_id          = aws_kms_key.this.arn
}

resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt Redshift"
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.this.json
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/520-green"
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


resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}