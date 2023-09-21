resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt secret parameters"
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.this.json
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "this" {
  name          = "alias/k-572-green"
  target_key_id = "${aws_kms_key.this.key_id}"
}

data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "Allow root"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root",
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
