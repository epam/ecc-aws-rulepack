resource "aws_s3_bucket" "this1" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}-1"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}

resource "aws_s3_bucket_policy" "this1" {
  bucket = aws_s3_bucket.this1.id
  policy = data.aws_iam_policy_document.this1.json
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this1.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
} 


resource "aws_s3_bucket" "this2" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}-2"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "this2" {
  bucket = aws_s3_bucket.this2.id
  policy = data.aws_iam_policy_document.this2.json
}

resource "aws_s3_bucket_policy" "deny" {
  bucket = aws_s3_bucket.this2.id
  policy = data.aws_iam_policy_document.deny.json

  depends_on = [
    aws_s3_bucket_policy.this2,
    aws_s3_bucket.this2,
    aws_cloudtrail.this2
  ]
}

resource "null_resource" "this" {
  depends_on = [
    aws_s3_bucket_policy.deny,
    aws_cloudtrail.this2
  ]
  triggers = {
    s3_name = aws_s3_bucket.this2.id
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
set -e
aws s3 rb s3://${self.triggers.s3_name} --force  
aws s3 ls > /dev/null
aws ec2 describe-security-groups > /dev/null
aws ec2 describe-vpcs > /dev/null
sleep 10m
EOF
  }
}
