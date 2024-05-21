resource "aws_cloudtrail" "this" {
  name                          = "${module.naming.resource_prefix.cloud_trail}"
  s3_bucket_name                = aws_s3_bucket.this.id
  enable_log_file_validation    = false
  provider                      = aws.provider2
  include_global_service_events = false

  event_selector {
    include_management_events = false
    read_write_type           = "WriteOnly"

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }
}

resource "aws_s3_bucket" "this" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}"
  force_destroy = true
  provider      = aws.provider2
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}
