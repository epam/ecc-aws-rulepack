# Trail for policies that require missing management events (ecc-aws-303) and untagged trails (provider2)
resource "aws_cloudtrail" "this" {
  name                          = "${module.naming.resource_prefix.cloud_trail}-1"
  s3_bucket_name                = aws_s3_bucket.this.id
  enable_log_file_validation    = false
  provider                      = aws.provider2
  include_global_service_events = false

  event_selector {
    include_management_events = false
    read_write_type           = "WriteOnly"

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }

  depends_on = [aws_s3_bucket_policy.this]
}

# Trail for delivery-failing (ecc-aws-544) and missing data events (ecc-aws-374)
resource "aws_cloudtrail" "delivery_failing" {
  name                          = "${module.naming.resource_prefix.cloud_trail}-2"
  s3_bucket_name                = aws_s3_bucket.delivery_failing.id
  enable_log_file_validation    = false
  include_global_service_events = false

  event_selector {
    include_management_events = true
    read_write_type           = "All"
  }

  depends_on = [aws_s3_bucket_policy.delivery_failing]
}

resource "aws_s3_bucket" "this" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}-1"
  force_destroy = true
  provider      = aws.provider2
}

resource "aws_s3_bucket" "delivery_failing" {
  bucket        = "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}-2"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_policy" "this" {
  bucket   = aws_s3_bucket.this.id
  policy   = data.aws_iam_policy_document.this.json
  provider = aws.provider2
}

resource "aws_s3_bucket_policy" "delivery_failing" {
  bucket = aws_s3_bucket.delivery_failing.id
  policy = data.aws_iam_policy_document.delivery_failing.json
}

# Deny CloudTrail writes after the trail is created so LatestDeliveryError is set (ecc-aws-544)
resource "aws_s3_bucket_policy" "deny" {
  bucket = aws_s3_bucket.delivery_failing.id
  policy = data.aws_iam_policy_document.deny.json

  depends_on = [
    aws_s3_bucket_policy.delivery_failing,
    aws_s3_bucket.delivery_failing,
    aws_cloudtrail.delivery_failing
  ]
}

# Generate management/API activity so CloudTrail attempts delivery
resource "null_resource" "generate_trail_events" {
  depends_on = [
    aws_s3_bucket_policy.deny,
    aws_cloudtrail.delivery_failing
  ]

  triggers = {
    trail_arn = aws_cloudtrail.delivery_failing.arn
  }

  provisioner "local-exec" {
    command = "aws s3 ls && aws ec2 describe-security-groups --region ${var.region} && aws ec2 describe-vpcs --region ${var.region}"
  }
}

# Wait for CloudTrail delivery attempt to fail and populate LatestDeliveryError
resource "time_sleep" "wait_delivery_error" {
  depends_on = [null_resource.generate_trail_events]

  create_duration = "10m"
}
