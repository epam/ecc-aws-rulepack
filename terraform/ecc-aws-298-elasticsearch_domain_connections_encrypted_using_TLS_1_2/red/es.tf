resource "aws_elasticsearch_domain" "this" {
  domain_name           = "domain-298-red"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }
}
