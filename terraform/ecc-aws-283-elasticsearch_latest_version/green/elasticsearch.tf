resource "aws_elasticsearch_domain" "this" {
  domain_name           = "elasticsearch-283-green"
  elasticsearch_version = "OpenSearch_2.3"

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }
}
