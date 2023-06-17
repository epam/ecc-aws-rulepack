resource "aws_elasticsearch_domain" "this" {
  domain_name           = "domain-298-green"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }
  
  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"    
  }
}
