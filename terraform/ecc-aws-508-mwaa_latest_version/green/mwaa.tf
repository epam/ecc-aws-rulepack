# takes 30 min to deploy, 20 min to destroy

resource "aws_mwaa_environment" "this" {
  dag_s3_path        = "dags/"
  execution_role_arn = aws_iam_role.this.arn
  name               = "mwaa_508_green"
  max_workers = 1

  network_configuration {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids         = [aws_subnet.private1.id, aws_subnet.private2.id]
  }

  source_bucket_arn = aws_s3_bucket.this.arn
  depends_on = [
    aws_route_table_association.route_table_nat_gateway1,
    aws_route_table_association.route_table_nat_gateway2
  ]
}

resource "aws_cloudwatch_log_group" "this" {
  name = "airflow-mwaa_508_green-Task"
}

resource "aws_s3_bucket" "this" {
  bucket = "508-bucket-${random_integer.this.result}-green"
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

