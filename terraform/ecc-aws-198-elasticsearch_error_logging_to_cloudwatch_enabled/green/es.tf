resource "aws_cloudwatch_log_group" "this" {
  name = "loggroup-elasticsearch-198"
}

resource "aws_cloudwatch_log_resource_policy" "this" {
  policy_name = "elasticsearch-198"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

resource "aws_elasticsearch_domain" "this" {
  domain_name           = "domain-198-green"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
  }

 ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }
  
  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "ES_APPLICATION_LOGS"
  }
}
