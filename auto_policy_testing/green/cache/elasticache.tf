resource "aws_elasticache_cluster" "this" {
  cluster_id               = "${module.naming.resource_prefix.elasticache}-cluster"
  replication_group_id     = aws_elasticache_replication_group.this.id
  # snapshot_retention_limit = 7
  
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.this.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.this.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "engine-log"
  }

  # notification_topic_arn   = aws_sns_topic.this.arn
}

resource "aws_sns_topic" "this" {
  name = "${module.naming.resource_prefix.elasticache}"
}

resource "aws_cloudwatch_log_group" "this" {
  name = "${module.naming.resource_prefix.elasticache}"
}
 
 resource "aws_elasticache_replication_group" "this" {
  at_rest_encryption_enabled = true
  kms_key_id                 = data.terraform_remote_state.common.outputs.kms_key_arn
  engine                     = "redis"
  replication_group_id       = module.naming.resource_prefix.elasticache
  description                = module.naming.resource_prefix.elasticache
  node_type                  = "cache.t2.micro"
  num_cache_clusters         = 2
  port                       = 6379
  subnet_group_name          = "${module.naming.resource_prefix.elasticache}-subnetgroup"
  multi_az_enabled           = false
  automatic_failover_enabled = true
  depends_on                 = [aws_elasticache_subnet_group.this]
  transit_encryption_enabled = true
  auth_token                 = random_password.this.result
}

resource "aws_elasticache_subnet_group" "this" {
  name = "${module.naming.resource_prefix.elasticache}-subnetgroup"

  subnet_ids = [
    data.terraform_remote_state.common.outputs.vpc_subnet_1_id,
    data.terraform_remote_state.common.outputs.vpc_subnet_2_id
  ]
}

resource "random_password" "this" {
  length           = 18
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  special          = false
}

# ecc-aws-265-elasticache_previous_generation_instances_not_used
resource "aws_elasticache_cluster" "memcached" {
  cluster_id               = "${module.naming.resource_prefix.elasticache}-cluster2"
  engine                   = "memcached"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 11211
}
