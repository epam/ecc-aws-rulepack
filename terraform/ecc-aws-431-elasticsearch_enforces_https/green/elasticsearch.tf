resource "aws_elasticsearch_domain" "this" {
  domain_name           = "elasticsearch-431-green"

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }
  cluster_config {
    instance_type = "t2.small.elasticsearch"
  }

  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }
}
