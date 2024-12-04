resource "aws_s3_bucket" "this" {
  bucket = "112-bucket-${random_integer.this.result}-green2"
  force_destroy = "true"
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}