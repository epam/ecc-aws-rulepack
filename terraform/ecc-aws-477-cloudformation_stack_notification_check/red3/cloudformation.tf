resource "aws_cloudformation_stack" "this" {
  name = "stack-477-red4"
  template_body = <<STACK
{
  "Resources" : {
    "SecurityGroupRed3": {
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
}

