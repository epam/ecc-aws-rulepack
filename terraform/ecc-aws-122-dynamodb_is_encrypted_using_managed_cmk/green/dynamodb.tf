resource "aws_dynamodb_table" "this" {
  name             = "122_dynamodb_table_green"
  hash_key         = "GreenTableHashKey"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "GreenTableHashKey"
    type = "S"
  }
  
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.this.arn
  }
}

resource "aws_kms_key" "this" {
  description             = "122_kms_key_green"
  deletion_window_in_days = 10
}