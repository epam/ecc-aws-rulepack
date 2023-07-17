resource "aws_s3_bucket" "this" {
  bucket        = "162-bucket-${random_integer.this.result}-green"
  force_destroy = "true"
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
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

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket
  
  rule {
    id = "log"

    expiration {
      days = 90
    }

    filter {
      and {
        prefix = "log/"
		
		tags = {
          CustodianRule    = "epam-aws-162-s3_bucket_lifecycle"
          ComplianceStatus = "Green"
        }
      }
    }

    status = "Enabled"

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}
