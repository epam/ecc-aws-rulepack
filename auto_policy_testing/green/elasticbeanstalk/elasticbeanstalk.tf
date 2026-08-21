data "aws_caller_identity" "this" {}

data "aws_elastic_beanstalk_solution_stack" "python" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux 2023 (.*) running Python 3\\.12$"
}

resource "aws_iam_role" "ec2" {
  name                 = "${module.naming.resource_prefix.beanstalk}-ec2"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_web" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "ec2_worker" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${module.naming.resource_prefix.beanstalk}-ec2"
  role = aws_iam_role.ec2.name
}

resource "aws_iam_role" "service" {
  name                 = "${module.naming.resource_prefix.beanstalk}-service"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "service_health" {
  role       = aws_iam_role.service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "service_updates" {
  role       = aws_iam_role.service.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
}

resource "aws_elastic_beanstalk_application" "this" {
  name        = module.naming.resource_prefix.beanstalk
  description = module.naming.resource_prefix.beanstalk
}

resource "aws_elastic_beanstalk_environment" "this" {
  name                   = module.naming.resource_prefix.beanstalk_env
  application            = aws_elastic_beanstalk_application.this.name
  solution_stack_name    = data.aws_elastic_beanstalk_solution_stack.python.name
  wait_for_ready_timeout = "30m"

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ec2.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.service.name
  }

  depends_on = [
    aws_iam_role_policy_attachment.ec2_web,
    aws_iam_role_policy_attachment.ec2_worker,
    aws_iam_role_policy_attachment.service_health,
    aws_iam_role_policy_attachment.service_updates,
  ]
}
