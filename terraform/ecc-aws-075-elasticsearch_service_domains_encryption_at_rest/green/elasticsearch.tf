resource "aws_elasticsearch_domain" "this" {
  domain_name           = "elasticsearch-075-green"
  elasticsearch_version = "7.4"

  encrypt_at_rest {
    enabled = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }
}
