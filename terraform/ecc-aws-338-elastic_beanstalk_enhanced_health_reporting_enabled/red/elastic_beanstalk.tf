resource "aws_elastic_beanstalk_application" "this" {
  name        = "338_application_red"
  description = "338_application_red"
}

resource "aws_elastic_beanstalk_environment" "this" {
  name                = "environment-338-red"
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