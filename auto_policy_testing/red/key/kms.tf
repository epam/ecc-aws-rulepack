# ecc-aws-523-kms_cmk_not_scheduled_for_deletion
# To get red resource(pending deletion) create and destroy terraform infrastructure before custodian scan

resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt secret parameters"
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.this.json
  deletion_window_in_days = 7
  is_enabled              = false
  enable_key_rotation     = false
  provider                = aws.provider2
}

resource "aws_kms_alias" "this" {
  name          = "alias/${module.naming.resource_prefix.kms_key}"
  target_key_id = aws_kms_key.this.key_id
  provider      = aws.provider2
}
