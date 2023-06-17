resource "aws_elasticsearch_domain" "this" {
  domain_name           = "domain-769-green"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type            = "t3.small.elasticsearch"
    dedicated_master_count   = 3
    dedicated_master_enabled = true
    dedicated_master_type    = "t3.small.elasticsearch"
  }
  
  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  node_to_node_encryption {
    enabled = true
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = "root"
      master_user_password = random_password.this.result
    }
  }
  
  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }
}


resource "random_password" "this" {
  length           = 12
  special          = true
  lower            = true
  numeric          = true  
  upper            = true
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1

  override_special = "!#$%*()-_=+[]{}:?"
}
