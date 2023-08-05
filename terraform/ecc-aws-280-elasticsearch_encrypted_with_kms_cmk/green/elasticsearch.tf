resource "aws_elasticsearch_domain" "this" {
  domain_name           = "elasticsearch-280-green"
  elasticsearch_version = "OpenSearch_1.1"
  

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }

  encrypt_at_rest {
    enabled    = true
    kms_key_id = aws_kms_key.this.arn
  }
}

resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt Elasticsearch"
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.this.json
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/280-green"
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