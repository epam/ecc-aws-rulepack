resource "aws_cloudformation_stack" "this" {
  name          = "stack-476-red"
  template_body = <<STACK
{
    "Resources": {
        "S3BucketRed" : {
          "Properties": {
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
    command = "aws s3api delete-bucket-tagging --bucket s3-bucket-476-red  && aws cloudformation detect-stack-drift --stack-name stack-476-red"
    interpreter = ["bash", "-c"]
  }

  depends_on = [time_sleep.this]
}