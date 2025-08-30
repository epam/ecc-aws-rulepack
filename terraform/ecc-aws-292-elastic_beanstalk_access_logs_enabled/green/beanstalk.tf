resource "aws_elastic_beanstalk_application" "this" {
  name = "292-beanstalk-application-green"
}

data "aws_elastic_beanstalk_solution_stack" "this" {
  most_recent = true
  name_regex = "^64bit Amazon Linux (.*) running Python (.*)$"
}

resource "aws_elastic_beanstalk_environment" "this" {
  name                = "292-beanstalk-environment-green"
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
    namespace = "aws:elbv2:loadbalancer"
    name = "AccessLogsS3Bucket"
    value = "${aws_s3_bucket.this.id}"
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name = "AccessLogsS3Enabled"
    value = "true"
  } 
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name = "ManagedActionsEnabled"
    value = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name = "PreferredStartTime"
    value = "Tue:09:00"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name = "ServiceRoleForManagedUpdates"
    value = "AWSServiceRoleForElasticBeanstalkManagedUpdates"
  }
  
  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name = "UpdateLevel"
    value = "minor"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "DisableIMDSv1"
    value = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:xray"
    name = "XRayEnabled"
    value = "true"
  }
  depends_on = [aws_s3_bucket_policy.this]
}

resource "aws_s3_bucket" "this" {
  bucket        = "292-bucket-${random_integer.this.result}-green"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1000
  max = 9999
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}
data "aws_elb_service_account" "this" {}
data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers =  ["arn:aws:iam::${data.aws_elb_service_account.this.id}:root"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }
}
