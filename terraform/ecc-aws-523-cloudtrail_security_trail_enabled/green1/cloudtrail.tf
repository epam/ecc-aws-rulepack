resource "aws_cloudtrail" "this" {
  name                          = "cloudtrail-523-green1"
  s3_bucket_name                = aws_s3_bucket.this.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  kms_key_id                    = aws_kms_key.this.arn

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

