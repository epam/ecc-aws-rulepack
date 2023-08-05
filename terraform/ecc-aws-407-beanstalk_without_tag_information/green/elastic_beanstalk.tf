resource "aws_elastic_beanstalk_application" "this" {
  name        = "407_application_green"
  description = "407_application_green"
}

resource "aws_elastic_beanstalk_environment" "this" {
  name                = "environment-407-green"
  application         = aws_elastic_beanstalk_application.this.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.7 running Python 3.8"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "basic"
  }
}