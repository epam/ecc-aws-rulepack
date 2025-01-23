resource "aws_s3_bucket" "this" {
  bucket = "437-bucket-${random_integer.this.result}-red"
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}
