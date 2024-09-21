# correct
resource "aws_cloudtrail" "this1" {
  name                          = "${module.naming.resource_prefix.trail}-1"
  s3_bucket_name                = aws_s3_bucket.this1.id
  cloud_watch_logs_role_arn     = aws_iam_role.this.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.this1.arn}:*"
  include_global_service_events = true
  is_multi_region_trail         = true

  advanced_event_selector {
    field_selector {
      field  = "eventCategory"
      equals = ["Management"]
    }
  }
  advanced_event_selector {
    field_selector {
      field  = "eventCategory"
      equals = ["Data"]
    }
    field_selector {
      field  = "resources.type"
      equals = ["AWS::DynamoDB::Table"]
    }
  }

  depends_on = [
    aws_s3_bucket.this1,
    aws_s3_bucket_policy.this1
  ]
}

# wrong
resource "aws_cloudtrail" "this2" {
  name                          = "${module.naming.resource_prefix.trail}-2"
  s3_bucket_name                = aws_s3_bucket.this1.id
  cloud_watch_logs_role_arn     = aws_iam_role.this.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.this2.arn}:*"
  include_global_service_events = false
  is_multi_region_trail         = false

  advanced_event_selector {
    field_selector {
      field  = "eventCategory"
      equals = ["Management"]
    }
    field_selector {
      field  = "readOnly"
      equals = ["false"]
    }
  }

  depends_on = [
    aws_s3_bucket.this1,
    aws_s3_bucket_policy.this1
  ]
}

