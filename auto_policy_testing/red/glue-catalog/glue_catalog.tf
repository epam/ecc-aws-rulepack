# Account-level singleton: one config must cover as many red policies as possible.
# SSE-KMS without a CMK -> alias/aws/glue (ecc-aws-253)
# Password encryption off -> AwsKmsKeyId absent (ecc-aws-365)
# Conflicts with ecc-aws-252 (needs CatalogEncryptionMode DISABLED) -> excepted
resource "aws_glue_data_catalog_encryption_settings" "this" {
  data_catalog_encryption_settings {
    encryption_at_rest {
      catalog_encryption_mode = "SSE-KMS"
    }

    connection_password_encryption {
      return_connection_password_encrypted = false
    }
  }
}
