resource "aws_s3_bucket" "this" {
  bucket = "080-bucket-red"
  force_destroy = true
}