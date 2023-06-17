resource "aws_glue_job" "this" {
  name         = "963_glue_job_red"
  role_arn     = aws_iam_role.this.arn

  command {
    script_location = "s3://${aws_s3_bucket.this.bucket}/script"
  }
}