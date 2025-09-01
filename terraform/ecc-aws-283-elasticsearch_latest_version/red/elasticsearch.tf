# takes about 20 min to deploy

resource "aws_elasticsearch_domain" "this" {
  domain_name           = "elasticsearch-283-red"
  elasticsearch_version = "OpenSearch_2.15"

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }
}
