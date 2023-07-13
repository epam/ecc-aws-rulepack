resource "aws_s3_bucket" "this" {
  bucket = "399-bucket-red"
  force_destroy = true
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

resource "aws_s3_object" "this" {
  bucket = aws_s3_bucket.this.id
  key    = "source/399-bucket-file.csv"
  source = "399-bucket-file.csv"
}

resource "aws_s3_object" "this2" {
  bucket = aws_s3_bucket.this.id
  key    = "destination/"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = <<EOF
{
    "Statement": [
        {
            "Effect": "Allow",
            "Sid": "AllowAppFlowSourceActions",
            "Principal": {
                "Service": "appflow.amazonaws.com"
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts",
                "s3:ListBucketMultipartUploads",
                "s3:GetBucketAcl",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::399-bucket-red",
                "arn:aws:s3:::399-bucket-red/*"
            ]
        }
    ],
    "Version": "2012-10-17"
}
EOF
}