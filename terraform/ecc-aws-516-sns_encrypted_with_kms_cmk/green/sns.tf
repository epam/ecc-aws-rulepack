resource "aws_sns_topic" "this" {
  name              = "rule-516-green"
  kms_master_key_id = aws_kms_key.this.arn
}

resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt sns"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/k-516"
  target_key_id = "${aws_kms_key.this.key_id}"
}