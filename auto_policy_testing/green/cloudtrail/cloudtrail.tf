resource "aws_cloudtrail" "this" {
  name                          = "${module.naming.resource_prefix.trail}"
  s3_bucket_name                = aws_s3_bucket.this.id
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.this.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.this.arn
  enable_log_file_validation    = true
  include_global_service_events = true
  is_multi_region_trail         = false
  enable_logging                = true
  kms_key_id                    = data.terraform_remote_state.common.outputs.kms_key_arn
  
  event_selector {
    include_management_events = true
    read_write_type           = "WriteOnly"

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }

  depends_on = [
    aws_s3_bucket.this,
    aws_s3_bucket_policy.this,
  ]
}

resource "aws_s3_bucket" "this" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_cloudwatch_log_group" "this" {
  name = "${module.naming.resource_prefix.cw_log_group}"
}

resource "aws_s3_bucket_logging" "this" {
  bucket        = aws_s3_bucket.this.id
  target_bucket = aws_s3_bucket.bucket_for_logging.id
  target_prefix = "log/"
}

resource "aws_s3_bucket" "bucket_for_logging" {
  bucket = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}-logs"
}
