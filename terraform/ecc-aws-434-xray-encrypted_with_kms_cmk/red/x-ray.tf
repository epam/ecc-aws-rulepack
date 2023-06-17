data "aws_kms_key" "this" {
  key_id = "alias/aws/xray"
}

resource "aws_xray_encryption_config" "this" {
  type   = "KMS"
  key_id = data.aws_kms_key.this.arn
}