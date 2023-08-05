resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt Lambda Variables"
  key_usage               = "ENCRYPT_DECRYPT"
#   policy                  = data.aws_iam_policy_document.this.json
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/460-green"
  target_key_id = aws_kms_key.this.key_id
}