resource "aws_s3_object" "this" {
  bucket = aws_s3_bucket.this.id
  key    = "script"
  acl    = "private"
  source = "script.py"
  etag = filemd5("script.py")
}

resource "aws_s3_bucket" "this" {
  bucket        = "bucket-600-red"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}