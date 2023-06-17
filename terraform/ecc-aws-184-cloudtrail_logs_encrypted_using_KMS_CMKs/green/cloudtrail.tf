resource "aws_cloudtrail" "this" {
  name                          = "cloudtrail-184-green"
  s3_bucket_name                = aws_s3_bucket.this.id
  enable_log_file_validation    = true
  include_global_service_events = true
  is_multi_region_trail         = false
  enable_logging                = true
  kms_key_id                    = aws_kms_key.this.arn
}