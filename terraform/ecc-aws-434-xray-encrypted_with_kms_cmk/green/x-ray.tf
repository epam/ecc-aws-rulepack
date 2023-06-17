resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt X-ray"
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.this.json
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true

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

# Removing this resource from Terraform has no effect to the encryption configuration within X-Ray.
resource "aws_xray_encryption_config" "this" {
  type   = "KMS"
  key_id = aws_kms_key.this.arn
}