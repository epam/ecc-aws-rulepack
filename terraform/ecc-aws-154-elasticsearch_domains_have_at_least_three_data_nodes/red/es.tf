resource "aws_elasticsearch_domain" "this" {
  domain_name = "domain-154-red"

  elasticsearch_version = "7.10"
  cluster_config {
    instance_count         = 2
    instance_type          = "t3.small.elasticsearch"
    zone_awareness_enabled = true

    zone_awareness_config {
      availability_zone_count = 2
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }
}
