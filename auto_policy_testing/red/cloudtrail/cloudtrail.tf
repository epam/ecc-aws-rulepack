resource "aws_cloudtrail" "this1" {
  provider                      = aws.provider2
  name                          = "${module.naming.resource_prefix.trail}-1"
  s3_bucket_name                = aws_s3_bucket.this1.id
  enable_log_file_validation    = false
  include_global_service_events = false

  event_selector {
    include_management_events = false
    read_write_type           = "WriteOnly"

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }

  depends_on = [ aws_s3_bucket_policy.this1 ]
}

resource "aws_cloudtrail" "this2" {
  name                          = "${module.naming.resource_prefix.trail}-2"
  s3_bucket_name                = aws_s3_bucket.this2.id
  enable_log_file_validation    = false
  include_global_service_events = false
  event_selector {
    include_management_events = true
    read_write_type           = "All"
  }
  
  depends_on = [ aws_s3_bucket_policy.this2 ]
}