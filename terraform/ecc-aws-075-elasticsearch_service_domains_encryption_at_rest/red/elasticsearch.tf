resource "aws_elasticsearch_domain" "this" {
  domain_name           = "elasticsearch-075-red"
  elasticsearch_version = "7.4"

  encrypt_at_rest {
    enabled = false
  }

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }
}
