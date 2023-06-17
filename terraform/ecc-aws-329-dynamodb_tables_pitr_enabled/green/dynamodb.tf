resource "aws_dynamodb_table" "this" {
  name         = "329_dynamodb_table_green"
  hash_key     = "GreenTableHashKey"
  billing_mode = "PAY_PER_REQUEST"

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "GreenTableHashKey"
    type = "S"
  }

}