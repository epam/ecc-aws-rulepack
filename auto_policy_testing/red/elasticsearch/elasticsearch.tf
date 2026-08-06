resource "aws_elasticsearch_domain" "this" {
  domain_name           = module.naming.resource_prefix.elasticsearch
  elasticsearch_version = "7.4"
  provider              = aws.provider2

  encrypt_at_rest {
    enabled = false
  }

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }
}
