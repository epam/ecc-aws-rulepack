resource "aws_elasticsearch_domain" "this" {
  domain_name           = "domain-155-green"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type            = "t3.small.elasticsearch"
    dedicated_master_count   = 3
    dedicated_master_enabled = true
    dedicated_master_type    = "t3.small.elasticsearch"
  }
  
  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }
}
