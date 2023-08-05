resource "aws_glue_data_catalog_encryption_settings" "this" {
  data_catalog_encryption_settings {
    encryption_at_rest {
      catalog_encryption_mode = "SSE-KMS"
      sse_aws_kms_key_id      = aws_kms_key.this.arn
    }

    connection_password_encryption {
      return_connection_password_encrypted = false
    }
  }
}

resource "aws_kms_key" "this" {
  description             = "365_kms_key_red"
  deletion_window_in_days = 7
}
