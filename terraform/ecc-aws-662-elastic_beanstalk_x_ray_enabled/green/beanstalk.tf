resource "aws_elastic_beanstalk_application" "this" {
  name        = "662-beanstalk-application-green"
}

resource "aws_elastic_beanstalk_environment" "this" {
  name                = "662-beanstalk-environment-green"
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
    namespace = "aws:elasticbeanstalk:xray"
    name = "XRayEnabled"
    value = "true"
  }
}

