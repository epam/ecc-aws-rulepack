resource "aws_cloudformation_stack" "this" {
  name          = "${module.naming.resource_prefix.cfn}"
  provider      = aws.provider2
  
  template_body = <<STACK
{
    "Resources": {
        "S3BucketRed" : {
          "Properties": {
            "VersioningConfiguration": {
              "Status": "Enabled"
            },
            "BucketName" : "s3-bucket-476-red"},
            "Type" : "AWS::S3::Bucket"
      }
    }
}
STACK
}

resource "time_sleep" "this" {
  depends_on = [aws_cloudformation_stack.this]

  create_duration = "60s"
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "aws s3api put-bucket-versioning --bucket s3-bucket-476-red --versioning-configuration Status=Suspended && aws cloudformation detect-stack-drift --stack-name ${module.naming.resource_prefix.cfn}"
    # interpreter = ["bash", "-c"]
  }

  depends_on = [time_sleep.this]
}