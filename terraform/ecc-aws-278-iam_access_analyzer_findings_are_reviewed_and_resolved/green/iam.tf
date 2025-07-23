resource "aws_accessanalyzer_analyzer" "this" {
  analyzer_name = "accessanalyzer-278-green"
}

resource "aws_s3_bucket" "this" {
  bucket = "278-bucket-${random_integer.this.result}-green"
}

resource "random_integer" "this" {
  min = 1000
  max = 9999
}
