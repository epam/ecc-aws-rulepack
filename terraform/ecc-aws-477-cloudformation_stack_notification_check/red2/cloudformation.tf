resource "aws_cloudformation_stack" "this" {
  name = "stack-477-red2"
  notification_arns = [aws_sns_topic.this.arn]
  template_body = <<STACK
{
  "Resources" : {
    "SecurotyGroupRed2": {
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
  name = "477_sns_red2"
}
