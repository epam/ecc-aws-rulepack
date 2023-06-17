resource "aws_glue_job" "this" {
  name         = "963_glue_job_green"
  role_arn     = aws_iam_role.this.arn
  default_arguments = {
    "--continuous-log-logGroup"          = aws_cloudwatch_log_group.this.name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
  }
  command {
    script_location = "s3://${aws_s3_bucket.this.bucket}/script"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "cloudwatch_log_group_963_green"
}