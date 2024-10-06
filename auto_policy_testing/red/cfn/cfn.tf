resource "aws_cloudformation_stack" "this" {
  name     = "${module.naming.resource_prefix.cfn}-1"
  provider = aws.provider2

  template_body = <<STACK
{
    "Resources": {
        "S3BucketRed" : {
          "Properties": {
            "VersioningConfiguration": {
              "Status": "Enabled"
            },
            "BucketName" : "${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result}"},
            "Type" : "AWS::S3::Bucket"
      }
    }
}
STACK

  depends_on = [random_integer.this]
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}

resource "time_sleep" "this" {
  depends_on = [aws_cloudformation_stack.this]

  create_duration = "60s"
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "aws s3api put-bucket-versioning --bucket ${module.naming.resource_prefix.s3_bucket}-${random_integer.this.result} --versioning-configuration Status=Suspended && aws cloudformation detect-stack-drift --stack-name ${module.naming.resource_prefix.cfn}-1"
    # interpreter = ["bash", "-c"]
  }

  depends_on = [time_sleep.this]
}