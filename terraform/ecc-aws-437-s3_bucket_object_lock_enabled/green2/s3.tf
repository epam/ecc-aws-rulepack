resource "aws_s3_bucket" "this" {
  bucket              = "437-bucket-${random_integer.this.result}-green-2"
  object_lock_enabled = true

}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  object_lock_enabled = "Enabled"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}