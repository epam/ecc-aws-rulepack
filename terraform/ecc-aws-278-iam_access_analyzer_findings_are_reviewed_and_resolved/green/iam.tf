resource "aws_accessanalyzer_analyzer" "this" {
  analyzer_name = "accessanalyzer-278-green"
  depends_on = [aws_s3_bucket_acl.this]
}

resource "aws_s3_bucket" "this" {
  bucket = "278-bucket-${random_integer.this.result}-green"
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
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