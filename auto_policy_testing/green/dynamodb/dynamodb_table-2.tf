resource "aws_dynamodb_table" "this2" {
  name           = "${module.naming.resource_prefix.dynamodb_table}-2"
  hash_key       = "GreenTableHashKey"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "GreenTableHashKey"
    type = "S"
  }
}

