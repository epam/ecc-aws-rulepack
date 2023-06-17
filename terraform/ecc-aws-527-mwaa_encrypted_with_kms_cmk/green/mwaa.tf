resource "aws_mwaa_environment" "this" {
  airflow_configuration_options = {
    "core.default_task_retries" = 16
    "core.parallelism"          = 1
  }

  dag_s3_path        = "dags/"
  execution_role_arn = aws_iam_role.this.arn
  name               = "mwaa_527_green"
  max_workers = 1
  kms_key = aws_kms_key.this.arn

  network_configuration {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids         = [aws_subnet.private1.id, aws_subnet.private2.id]
  }

  source_bucket_arn = aws_s3_bucket.this.arn
}

resource "aws_s3_bucket" "this" {
  bucket = "527-bucket-green"
}

resource "aws_s3_bucket_acl" "this" {
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

resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt secret parameters"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/k-527"
  target_key_id = "${aws_kms_key.this.key_id}"
}

