resource "aws_mwaa_environment" "this" {
  airflow_configuration_options = {
    "core.default_task_retries" = 16
    "core.parallelism"          = 1
  }

  dag_s3_path        = "dags/"
  execution_role_arn = aws_iam_role.this.arn
  name               = "mwaa_448_green"
  max_workers = 1

  logging_configuration {
     worker_logs {
      enabled   = true
      log_level = "DEBUG"
    }
  }

  network_configuration {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids         = [aws_subnet.private1.id, aws_subnet.private2.id]
  }

  source_bucket_arn = aws_s3_bucket.this.arn
}

resource "aws_s3_bucket" "this" {
  bucket = "448-bucket-${random_integer.this.result}-green"
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "this" {
  key        = "dags/code.py"
  bucket     = aws_s3_bucket.this.id
  source     = "code.py"
}

