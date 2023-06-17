resource "aws_cloudwatch_log_group" "this" {
  name = "295_cloudwatch_log_group_green"
}

resource "aws_cloudwatch_log_resource_policy" "this" {
  policy_name = "295_policy_green"

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

data "aws_caller_identity" "this" {}

resource "aws_elasticsearch_domain" "this" {
  domain_name = "domain-295-green"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
  }  
  
  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  node_to_node_encryption {
    enabled = true
  }
  encrypt_at_rest  {
    enabled    = true
  }

  advanced_security_options {
    enabled = true
    internal_user_database_enabled = true
    master_user_options {
       master_user_name = "root"
       master_user_password = random_password.this.result
     }
  }

  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "AUDIT_LOGS"
  }
}

resource "aws_kms_key" "this" {
  description             = "295_kms_key_green"
  deletion_window_in_days = 10
}

resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}