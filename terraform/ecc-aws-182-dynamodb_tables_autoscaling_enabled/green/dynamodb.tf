resource "aws_dynamodb_table" "this" {
  name         = "182_dynamodb_table_green"
  hash_key     = "GreenTableHashKey"
  billing_mode = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1


  attribute {
    name = "GreenTableHashKey"
    type = "S"
  }
}

resource "aws_appautoscaling_target" "this" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.this.id}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [aws_dynamodb_table.this]
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

    depends_on = [aws_dynamodb_table.this]
}