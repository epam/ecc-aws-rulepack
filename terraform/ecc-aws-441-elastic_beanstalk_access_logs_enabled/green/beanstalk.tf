resource "aws_elastic_beanstalk_application" "this" {
  name = "441-beanstalk-application-green"
}

resource "aws_elastic_beanstalk_environment" "this" {
  name                = "441-beanstalk-environment-green"
  application         = aws_elastic_beanstalk_application.this.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.13 running Python 3.8"
  tier                = "WebServer"
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = "application"
  } 
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "t2.micro"
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name = "AccessLogsS3Bucket"
    value = "bucket-441-green"
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name = "AccessLogsS3Enabled"
    value = "true"
  } 
}

resource "aws_s3_bucket" "this" {
  bucket        = "bucket-441-green"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::bucket-441-green/*"]
  }
}

