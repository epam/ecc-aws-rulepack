resource "aws_cloudformation_stack" "this2" {
  name = "${module.naming.resource_prefix.cfn}-2"
  notification_arns = [aws_sns_topic.this.arn]
  template_body = <<STACK
{
  "Resources" : {
    "SecurotyGroupRed": {
      "Type" : "AWS::EC2::SecurityGroup",
      "Properties" : {
        "GroupDescription" : "Enable HTTP access via port 80 locked down to the load balancer + SSH access",
      "SecurityGroupIngress" : [
        {"IpProtocol" : "tcp", "FromPort" : 80, "ToPort" : 80, "CidrIp" : "10.0.0.0/24"}
      ]
      }
    }
  }
}
STACK
}