resource "aws_dms_replication_instance" "this" {
  allocated_storage            = 5
  apply_immediately            = true
  publicly_accessible          = false
  replication_instance_class   = "dms.t2.micro"
  replication_instance_id      = "dms-replication-instance-313-green"
  engine_version               = "3.4.6"
  auto_minor_version_upgrade   = true
  kms_key_arn                  = aws_kms_key.this.arn
  depends_on = [
    null_resource.this
  ]
}

resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt DMS"
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.this.json
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/313-green"
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
