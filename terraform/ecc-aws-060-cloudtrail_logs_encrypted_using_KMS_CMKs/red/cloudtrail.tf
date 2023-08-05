resource "aws_cloudtrail" "this" {
  name                          = "cloudtrail-060-red"
  s3_bucket_name                = aws_s3_bucket.this.id
  enable_log_file_validation    = true
  include_global_service_events = true
  is_multi_region_trail         = false
  enable_logging                = true
}