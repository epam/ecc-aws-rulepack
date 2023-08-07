resource "aws_cloudformation_stack" "this" {
  name          = "stack-476-green"
  template_body = <<STACK
{
  "Resources" : {
    "SecurotyGroup476Green": {
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

resource "time_sleep" "this" {
  depends_on = [aws_cloudformation_stack.this]

  create_duration = "60s"
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "aws cloudformation detect-stack-drift --stack-name stack-476-green"
    interpreter = ["bash", "-c"]
  }

  depends_on = [time_sleep.this]
}