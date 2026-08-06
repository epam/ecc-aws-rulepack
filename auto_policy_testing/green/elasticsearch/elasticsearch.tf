resource "aws_cloudwatch_log_group" "this" {
  name = module.naming.resource_prefix.elasticsearch
}

resource "aws_iam_service_linked_role" "this" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_cloudwatch_log_resource_policy" "this" {
  policy_name = module.naming.resource_prefix.elasticsearch

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
        "arn:aws:logs:${var.region}:${data.aws_caller_identity.this.account_id}:log-group:${aws_cloudwatch_log_group.this.name}:log-stream:*"
      ]
    }
  ]
}
CONFIG
}

resource "aws_elasticsearch_domain" "this" {
  domain_name           = module.naming.resource_prefix.elasticsearch
  elasticsearch_version = "OpenSearch_2.11"

  cluster_config {
    instance_type            = "m6g.large.elasticsearch"
    dedicated_master_count   = 3
    dedicated_master_enabled = true
    dedicated_master_type    = "m6g.large.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp3"
    throughput  = 125
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled    = true
    kms_key_id = data.terraform_remote_state.common.outputs.kms_key_arn
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true

    master_user_options {
      master_user_name     = "root"
      master_user_password = random_password.this.result
    }
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-PFS-2023-10"
  }

  auto_tune_options {
    desired_state       = "ENABLED"
    rollback_on_disable = "NO_ROLLBACK"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "INDEX_SLOW_LOGS"
    enabled                  = true
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "SEARCH_SLOW_LOGS"
    enabled                  = true
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "AUDIT_LOGS"
    enabled                  = true
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "ES_APPLICATION_LOGS"
    enabled                  = true
  }

  vpc_options {
    subnet_ids = [
      data.terraform_remote_state.common.outputs.vpc_subnet_1_id
    ]
  }
  depends_on = [aws_iam_service_linked_role.this]
}

resource "random_password" "this" {
  length           = 12
  special          = true
  lower            = true
  numeric          = true
  upper            = true
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "!#$%*()-_=+[]{}:?"
}