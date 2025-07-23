# Confirm subscription to get green infrastructure

resource "aws_cloudformation_stack" "this" {
  name              = "stack-477-green"
  notification_arns = [aws_sns_topic.this.arn]
  template_body     = <<STACK
{
  "Resources" : {
    "SecurityGroupGreen": {
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

resource "aws_sns_topic" "this" {
  name = "477_sns_green"
}

resource "aws_sqs_queue" "this" {
  name = "097-sqs-green"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this.arn
}