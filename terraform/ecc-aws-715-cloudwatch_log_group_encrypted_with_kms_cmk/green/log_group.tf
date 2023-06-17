resource "aws_cloudwatch_log_group" "this" {
  name       = "cloudwatch_715_log_group_green"
  kms_key_id = aws_kms_key.this.arn
}

resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt Cloudwatch Log Group"
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.this.json
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/715-green"
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
