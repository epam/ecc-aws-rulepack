resource "aws_s3_bucket" "this" {
  bucket = "bucket-246-red"
  force_destroy = "true"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Suspended"
    mfa_delete = "Disabled"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {

	statement {
      effect = "Allow"
	  
      principals {
	    type        = "AWS"
        identifiers = ["*"]
        }
      actions = ["*"]
      resources = ["arn:aws:s3:::bucket-246-red/*"]
	}
}