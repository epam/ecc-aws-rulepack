resource "aws_glue_job" "this" {
  name         = "672_glue_job_green"
  role_arn     = aws_iam_role.this.arn
  default_arguments = {
    "--enable-spark-ui" = "true"
  }
  command {
    script_location = "s3://${aws_s3_bucket.this.bucket}/script"
  }
}