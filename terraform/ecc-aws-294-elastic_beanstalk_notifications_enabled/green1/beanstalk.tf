resource "aws_elastic_beanstalk_application" "this" {
  name = "294-beanstalk-application-green"
}

data "aws_elastic_beanstalk_solution_stack" "this" {
  most_recent = true
  name_regex = "^64bit Amazon Linux (.*) running Python (.*)$"
}

resource "aws_elastic_beanstalk_environment" "this" {
  name                = "294-beanstalk-environment-green1"
  application         = aws_elastic_beanstalk_application.this.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.this.name
  tier                = "WebServer"
  
  #doc: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elbv2
  # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-loadbalancer-accesslogs.html

  
  setting {
    namespace = "aws:autoscaling:asg"
    name = "MaxSize"
    value = 2
  }
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = aws_iam_instance_profile.this.name
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "DisableDefaultEC2SecurityGroup"
    value = true
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "t2.micro"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "SecurityGroups"
    value = aws_security_group.this.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "RootVolumeSize"
    value = 10
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "VPCId"
    value = aws_vpc.this.id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = "${aws_subnet.this1.id}, ${aws_subnet.this2.id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBSubnets"
    value = "${aws_subnet.this1.id}, ${aws_subnet.this2.id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBScheme"
    value = "public"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = true
  }

  setting {
      namespace = "aws:elasticbeanstalk:environment"
      name = "EnvironmentType"
      value = "LoadBalanced"
  } 
  setting {
      namespace = "aws:elasticbeanstalk:environment"
      name = "ServiceRole"
      value = aws_iam_role.this2.name
  }
  setting {
      namespace = "aws:elasticbeanstalk:environment"
      name = "LoadBalancerType"
      value = "application"
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name = "SecurityGroups"
    value = aws_security_group.this.id
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name = "ManagedSecurityGroup"
    value = aws_security_group.this.id
  }

  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name = "Notification Endpoint"
    value = "example1@email.com"
  }
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name = "Notification Endpoint"
    value = "example2@email.com"
  }
}

# use this queue to subscribe to the topic in order to receive notifications
resource "aws_sqs_queue" "this" {
  name = "294-sqs-green"
}
