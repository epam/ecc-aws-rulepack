resource "aws_cloudtrail" "this" {
  name                          = "cloudtrail-358-red1"
  s3_bucket_name                = aws_s3_bucket.this.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  advanced_event_selector {
    field_selector {
      field  = "eventCategory"
      equals = ["Management"]
    }
    field_selector {
      field  = "eventSource"
      not_equals = ["rdsdata.amazonaws.com"]
    }
  }
  depends_on = [
    aws_s3_bucket_acl.this
  ]
}

