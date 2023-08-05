# Do not confirm subscription to get red infrastructure

resource "aws_cloudformation_stack" "this" {
  name = "stack-477-red"
  notification_arns = [aws_sns_topic.this.arn]
  template_body = <<STACK
{
  "Resources" : {
    "SecurotyGroupRed": {
      "Type" : "AWS::EC2::SecurityGroup",
      "Properties" : {
        "GroupDescription" : "Enable HTTP access via port 80 locked down to the load balancer + SSH access",
      "SecurityGroupIngress" : [
        {"IpProtocol" : "tcp", "FromPort" : 80, "ToPort" : 80, "CidrIp" : "0.0.0.0/0"}
      ]
      }
    }
  }
}
STACK

depends_on = [aws_sns_topic.this]
}

resource "aws_sns_topic" "this" {
  name = "477_sns_red"
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command = join(" ", [
      "aws sns subscribe",
      "--topic-arn ${aws_sns_topic.this.arn}",
      "--protocol email",
      "--notification-endpoint ${var.test-email}",
      "--profile ${var.profile}",
      "--region ${var.default-region}"
      
      ]
    )
  }
}