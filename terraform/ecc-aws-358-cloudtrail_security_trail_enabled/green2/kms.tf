data "aws_caller_identity" "this" {}

resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt"
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.kms.json
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/358-green2"
  target_key_id = aws_kms_key.this.key_id
}

data "aws_iam_policy_document" "kms" {
  statement {
    sid    = "Enable IAM user permissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root",
      ]
    }
    actions = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow CloudTrail to describe key"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = ["kms:DescribeKey"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow CloudTrail to encrypt logs"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = ["kms:GenerateDataKey*"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.this.account_id}:trail/*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cloudtrail:${var.default-region}:${data.aws_caller_identity.this.account_id}:trail/${local.trail_name}",
      ]
    }
  }

  statement {
    sid    = "Allow principals in the account to decrypt log files"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    actions = ["kms:Decrypt", "kms:ReEncryptFrom"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.this.account_id}:trail/*"]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values = [
        "${data.aws_caller_identity.this.account_id}",
      ]
    }
  }
}