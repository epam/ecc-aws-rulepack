resource "aws_dynamodb_table" "this1" {
  name           = "${module.naming.resource_prefix.dynamodb_table}-1"
  hash_key       = "GreenTableHashKey"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = data.terraform_remote_state.common.outputs.kms_key_arn
  }

  attribute {
    name = "GreenTableHashKey"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "this" {
  table_name = aws_dynamodb_table.this1.name
  hash_key   = aws_dynamodb_table.this1.hash_key

  item = <<ITEM
{
  "GreenTableHashKey": {"S": "something"},
  "one": {"N": "11111"},
  "two": {"N": "22222"},
  "three": {"N": "33333"},
  "four": {"N": "44444"}
}
ITEM
}

resource "aws_appautoscaling_target" "this" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.this1.id}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "this" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.this.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = 70
  }
}