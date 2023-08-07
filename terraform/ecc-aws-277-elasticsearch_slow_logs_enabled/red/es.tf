data "aws_caller_identity" "this" {}

resource "aws_cloudwatch_log_group" "this" {
  name = "277_cloudwatch_log_group_red"
}

resource "aws_cloudwatch_log_resource_policy" "this" {
  policy_name = "277_policy_red"

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
      "Resource": [
       "arn:aws:logs:${var.default-region}:${data.aws_caller_identity.this.account_id}:log-group:${aws_cloudwatch_log_group.this.name}:log-stream:*"
      ]
    }
  ]
}
CONFIG
}

resource "aws_elasticsearch_domain" "this" {
  domain_name           = "domain-277-red"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

    log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "SEARCH_SLOW_LOGS"
    enabled                  = true
  }

  depends_on=[aws_cloudwatch_log_group.this, aws_cloudwatch_log_resource_policy.this]
}
