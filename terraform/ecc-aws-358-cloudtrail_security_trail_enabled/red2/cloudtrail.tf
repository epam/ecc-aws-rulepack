resource "aws_cloudtrail" "this" {
  name                          = "cloudtrail-358-red2"
  s3_bucket_name                = aws_s3_bucket.this.id
  include_global_service_events = false
  is_multi_region_trail         = false
  enable_log_file_validation    = true

  advanced_event_selector {
    field_selector {
      field  = "eventCategory"
      equals = ["Management"]
    }
  }
  depends_on = [
    aws_s3_bucket_acl.this
  ]
}

