
resource "aws_s3_bucket" "this" {
  bucket        = "${module.naming.resource_prefix.redshift_cluster}-${random_integer.this.result}"
  force_destroy = "true"
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

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}
