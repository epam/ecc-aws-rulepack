# resource "aws_cloudformation_stack" "this" {
#   name              = "${module.naming.resource_prefix.cfn}"
#   notification_arns = [aws_sns_topic.this1.arn,aws_sns_topic.this2.arn]
#   template_body     = <<STACK
# {
#   "Resources" : {
#     "SecurotyGroupGreen": {
#       "Type" : "AWS::EC2::SecurityGroup",
#       "Properties" : {
#         "GroupDescription" : "Enable HTTP access via port 80 locked down to the load balancer + SSH access",
#       "SecurityGroupIngress" : [
#         {"IpProtocol" : "tcp", "FromPort" : 80, "ToPort" : 80, "CidrIp" : "0.0.0.0/0"}
#       ]
#       }
#     }
#   }
# }
# STACK

# depends_on = [aws_sns_topic.this1,aws_sns_topic.this2]
# }

# resource "aws_sns_topic" "this1" {
#   name = "${module.naming.resource_prefix.sns}_1"
# }

# resource "aws_sns_topic" "this2" {
#   name = "${module.naming.resource_prefix.sns}_2"
# }

# resource "null_resource" "this1" {
#   provisioner "local-exec" {
#     command = join(" ", [
#       "aws sns subscribe",
#       "--topic-arn ${aws_sns_topic.this1.arn}",
#       "--protocol email",
#       "--notification-endpoint ${var.test-email}",
#       "--profile ${var.profile}",
#       "--region ${var.region}"
#       ]
#     )
#   }
# }

# resource "null_resource" "this2" {
#   provisioner "local-exec" {
#     command = join(" ", [
#       "aws sns subscribe",
#       "--topic-arn ${aws_sns_topic.this2.arn}",
#       "--protocol email",
#       "--notification-endpoint ${var.test-email}",
#       "--profile ${var.profile}",
#       "--region ${var.region}"
#       ]
#     )
#   }
# }

resource "aws_cloudformation_stack" "this" {
  name = "${module.naming.resource_prefix.cfn}"

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
          {"Key": "Name", "Value": "Primary_CF_VPC"}
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
