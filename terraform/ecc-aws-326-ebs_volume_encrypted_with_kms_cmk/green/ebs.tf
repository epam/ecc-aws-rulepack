resource "aws_ebs_volume" "this" {
  availability_zone = "us-east-1a"
  size              = 5
  encrypted         = true
  kms_key_id        = aws_kms_key.this.arn
  
  tags = {
    Name = "326-ebs-volume-green"
  }
}

resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt EBS Volume"
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

resource "aws_kms_alias" "this" {
  name          = "alias/326-green"
  target_key_id = aws_kms_key.this.key_id
}
