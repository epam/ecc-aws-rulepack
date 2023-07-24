resource "aws_elastic_beanstalk_application" "this" {
  name        = "443-beanstalk-application-green"
  description = "tf-test-desc"
}

resource "aws_elastic_beanstalk_environment" "this" {
  name                = "443-beanstalk-environment-green"
  application         = aws_elastic_beanstalk_application.this.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.13 running Python 3.8"
  tier                = "WebServer"
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "aws-elasticbeanstalk-ec2-role"
  } 
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "t2.micro"
  }
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name = "Notification Protocol"
    value = "email"
  }
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name = "Notification Endpoint"
    value = var.test-email
  }
}

