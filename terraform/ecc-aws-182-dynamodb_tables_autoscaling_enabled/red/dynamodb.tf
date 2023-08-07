resource "aws_dynamodb_table" "this" {
  name         = "182_dynamodb_table_red"
  hash_key     = "GreenTableHashKey"
  billing_mode = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "GreenTableHashKey"
    type = "S"
  }

}
