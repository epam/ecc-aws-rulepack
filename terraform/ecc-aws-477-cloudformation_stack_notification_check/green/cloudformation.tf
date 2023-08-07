# Confirm subscription to get green infrastructure

resource "aws_cloudformation_stack" "this" {
  name              = "stack-477-green"
  notification_arns = [aws_sns_topic.this1.arn,aws_sns_topic.this2.arn]
  template_body     = <<STACK
{
  "Resources" : {
    "SecurotyGroupGreen": {
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

depends_on = [aws_sns_topic.this1,aws_sns_topic.this2]
}

resource "aws_sns_topic" "this1" {
  name = "477_sns_green1"
}

resource "aws_sns_topic" "this2" {
  name = "477_sns_green2"
}

resource "null_resource" "this1" {
  provisioner "local-exec" {
    command = join(" ", [
      "aws sns subscribe",
      "--topic-arn ${aws_sns_topic.this1.arn}",
      "--protocol email",
      "--notification-endpoint ${var.test-email}",
      "--profile ${var.profile}",
      "--region ${var.default-region}"
      ]
    )
  }
}

resource "null_resource" "this2" {
  provisioner "local-exec" {
    command = join(" ", [
      "aws sns subscribe",
      "--topic-arn ${aws_sns_topic.this2.arn}",
      "--protocol email",
      "--notification-endpoint ${var.test-email}",
      "--profile ${var.profile}",
      "--region ${var.default-region}"
      ]
    )
  }
}