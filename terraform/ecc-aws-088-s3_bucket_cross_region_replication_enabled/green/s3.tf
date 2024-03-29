resource "aws_s3_bucket" "bucket1" {
  bucket        = "088-bucket1-${random_integer.this.result}-green"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_versioning" "bucket1" {
  bucket = aws_s3_bucket.bucket1.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "bucket1" {
  depends_on = [aws_s3_bucket_versioning.bucket1]

  role   = aws_iam_role.this.arn
  bucket = aws_s3_bucket.bucket1.id

  rule {
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.bucket2.arn
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3_bucket" "bucket2" {
  bucket        = "088-bucket2-${random_integer.this.result}-green"
  force_destroy = true
} 

resource "aws_s3_bucket_versioning" "bucket2" {
  bucket = aws_s3_bucket.bucket2.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "this" {
  name = "088_role_green"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "this" {
  name = "088_policy_green"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket",
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"        
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}