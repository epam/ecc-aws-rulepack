resource "aws_s3_bucket" "this" {
  bucket = "899-s3-bucket-red"
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}
