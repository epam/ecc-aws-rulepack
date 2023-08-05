resource "aws_elastic_beanstalk_application" "this" {
  name        = "192_application_green"
  description = "192_application_green"
}

resource "aws_elastic_beanstalk_environment" "this" {
  name                = "environment-192-green"
  application         = aws_elastic_beanstalk_application.this.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.7 running Python 3.8"

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
}