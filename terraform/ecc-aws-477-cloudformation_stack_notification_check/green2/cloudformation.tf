# Confirm subscription to get green infrastructure

resource "aws_cloudformation_stack" "this" {
  name              = "stack-477-green2"
  notification_arns = [aws_sns_topic.this1.arn,aws_sns_topic.this2.arn]
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

depends_on = [aws_sns_topic_subscription.this1,aws_sns_topic_subscription.this2]
}

resource "aws_sns_topic" "this1" {
  name = "477_sns_green1"
}

resource "aws_sns_topic" "this2" {
  name = "477_sns_green2"
}


resource "aws_sqs_queue" "this" {
  name = "097-sqs-green"
}

resource "aws_sns_topic_subscription" "this1" {
  topic_arn = aws_sns_topic.this1.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this.arn
}

resource "aws_sns_topic_subscription" "this2" {
  topic_arn = aws_sns_topic.this2.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this.arn
}