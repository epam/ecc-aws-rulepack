resource "aws_elasticsearch_domain" "this" {
  domain_name           = "elasticsearch-283-red"
  elasticsearch_version = "7.4"

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }
}
