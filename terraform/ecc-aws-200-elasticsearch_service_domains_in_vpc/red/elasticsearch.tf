resource "aws_elasticsearch_domain" "this" {
  domain_name = "elasticsearch-200-red"

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }
}