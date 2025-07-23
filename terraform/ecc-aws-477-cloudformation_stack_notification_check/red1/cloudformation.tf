# Do not confirm subscription to get red infrastructure

resource "aws_cloudformation_stack" "this" {
  name = "stack-477-red1"
  # notification_arns = [aws_sns_topic.this1.arn,aws_sns_topic.this2.arn]
  template_body = <<STACK
{
  "Resources" : {
    "SecurityGroupRed1": {
      "Type" : "AWS::EC2::SecurityGroup",
      "Properties" : {
        "GroupDescription" : "Enable HTTP access via port 80 locked down to the load balancer + SSH access",
      "SecurityGroupIngress" : [
        {"IpProtocol" : "tcp", "FromPort" : 80, "ToPort" : 80, "CidrIp" : "10.0.0.0/32"}
      ]
      }
    }
  }
}
STACK

depends_on = [aws_sns_topic.this1,aws_sns_topic.this2]
}

resource "aws_sns_topic" "this1" {
  name = "477_sns_red1_1"
}

# resource "null_resource" "this1" {
#   provisioner "local-exec" {
#     command = join(" ", [
#       "aws sns subscribe",
#       "--topic-arn ${aws_sns_topic.this1.arn}",
#       "--protocol email",
#       "--notification-endpoint ${var.test-email}",
#       "--profile ${var.profile}",
#       "--region ${var.default-region}"
      
#       ]
#     )
#   }
# }

resource "aws_sns_topic" "this2" {
  name = "477_sns_red1_2"
}

# resource "null_resource" "this2" {
#   provisioner "local-exec" {
#     command = join(" ", [
#       "aws sns subscribe",
#       "--topic-arn ${aws_sns_topic.this2.arn}",
#       "--protocol email",
#       "--notification-endpoint ${var.test-email}",
#       "--profile ${var.profile}",
#       "--region ${var.default-region}"
      
#       ]
#     )
#   }
# }