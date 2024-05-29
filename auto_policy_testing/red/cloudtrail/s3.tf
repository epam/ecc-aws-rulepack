resource "aws_s3_bucket" "this" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_s3_bucket_policy" "deny" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.deny.json

  depends_on = [
    aws_s3_bucket_policy.this,
    aws_s3_bucket.this,
    aws_cloudtrail.this1,
    aws_cloudtrail.this2
  ]
}

resource "null_resource" "this" {
  depends_on = [
    aws_s3_bucket_policy.this,
    aws_s3_bucket_policy.deny,
    aws_s3_bucket.this,
    aws_cloudtrail.this1,
    aws_cloudtrail.this2
  ]
  triggers = {
    s3_name = aws_s3_bucket.this.id
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
