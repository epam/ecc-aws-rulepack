resource "aws_ecs_cluster" "this" {
  name = "464_ecs_cluster_green"

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        s3_bucket_name               = aws_s3_bucket.this.id
        s3_key_prefix                = "exec-output"
      }
    }
  }
}