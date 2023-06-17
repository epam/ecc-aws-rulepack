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