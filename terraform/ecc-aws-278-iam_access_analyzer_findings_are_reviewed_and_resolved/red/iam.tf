resource "aws_accessanalyzer_analyzer" "this" {
  analyzer_name = "accessanalyzer-278-red"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_accessanalyzer_analyzer.this.arn] # Does not work, works with external accaunt "AWS": "arn:aws:iam::11111111:root"
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}

resource "aws_s3_bucket" "this" {
  bucket = "278-bucket-${random_integer.this.result}-red"
  force_destroy= true
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}
