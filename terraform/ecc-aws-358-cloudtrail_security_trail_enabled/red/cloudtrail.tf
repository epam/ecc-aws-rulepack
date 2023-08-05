resource "aws_cloudtrail" "this" {
  name                          = "cloudtrail-358-red"
  s3_bucket_name                = aws_s3_bucket.this.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
    exclude_management_event_sources = ["kms.amazonaws.com"]
  }
  depends_on = [
    aws_s3_bucket_acl.this
  ]
}

