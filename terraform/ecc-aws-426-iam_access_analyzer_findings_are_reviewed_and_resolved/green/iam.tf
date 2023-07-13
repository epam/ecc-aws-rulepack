resource "aws_accessanalyzer_analyzer" "this" {
  analyzer_name = "accessanalyzer-426-green"
  depends_on = [aws_s3_bucket_acl.this]
}

resource "aws_s3_bucket" "this" {
  bucket = "426-bucket-green"
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}