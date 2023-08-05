resource "aws_glue_job" "this" {
  name         = "540_glue_job_green"
  role_arn     = aws_iam_role.this.arn
  glue_version = "4.0"

  command {
    script_location = "s3://${aws_s3_bucket.this.bucket}/script"
  }
}