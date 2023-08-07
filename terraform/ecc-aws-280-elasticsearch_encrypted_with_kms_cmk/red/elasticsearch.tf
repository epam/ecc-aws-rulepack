resource "aws_elasticsearch_domain" "this" {
  domain_name           = "elasticsearch-280-red"
  elasticsearch_version = "OpenSearch_1.1"
  

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }

  encrypt_at_rest {
    enabled    = true
  }
}
