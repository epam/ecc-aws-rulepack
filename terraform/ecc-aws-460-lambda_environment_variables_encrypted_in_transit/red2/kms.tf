resource "aws_kms_key" "this" {
  description             = "CMK for Lambda env vars at rest (red2: requires scanner kms:Decrypt)"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/460-red-kms"
  target_key_id = aws_kms_key.this.key_id
}
