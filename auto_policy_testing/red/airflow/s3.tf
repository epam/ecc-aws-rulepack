resource "random_integer" "this" {
  min = 10000
  max = 99999
}

resource "aws_s3_bucket" "this" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}-1"
  force_destroy = true
}

resource "aws_s3_object" "this" {
  key        = "dags/code.py"
  bucket     = aws_s3_bucket.this.id
  source     = "code.py"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}
