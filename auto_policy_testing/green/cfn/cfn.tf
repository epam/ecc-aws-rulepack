resource "aws_cloudformation_stack" "this" {
  name = module.naming.resource_prefix.cfn
  notification_arns = [aws_sns_topic.this.arn]

  parameters = {
    VPCCidr = "10.0.0.0/16"
  }

  template_body = <<STACK
{
  "Parameters" : {
    "VPCCidr" : {
      "Type" : "String",
      "Default" : "10.0.0.0/16",
      "Description" : "Enter the CIDR block for the VPC. Default is 10.0.0.0/16."
    }
  },
  "Resources" : {
    "myVpc": {
      "Type" : "AWS::EC2::VPC",
      "Properties" : {
        "CidrBlock" : { "Ref" : "VPCCidr" },
        "Tags" : [
          {"Key": "Name", "Value": "${module.naming.resource_prefix.vpc}"}
        ]
      }
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
    command = "aws cloudformation detect-stack-drift --stack-name ${module.naming.resource_prefix.cfn}"
    # interpreter = ["bash", "-c"]
  }

  depends_on = [time_sleep.this]
}
