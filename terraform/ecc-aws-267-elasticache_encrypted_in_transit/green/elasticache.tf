# takes about 8 minutes to deploy

resource "aws_elasticache_replication_group" "redis-replication-group" {
  engine                     = "redis"
  replication_group_id       = "elasticache-group-redis-267"
  description                = "elasticache-group-redis-267"
  node_type                  = "cache.t2.micro"
  cluster_mode               = "enabled"
  automatic_failover_enabled = true
  num_node_groups            = 1
  replicas_per_node_group    = 1
  transit_encryption_enabled = true
  auth_token                 = "abcdefgh1234567890"
  at_rest_encryption_enabled = true
  auth_token_update_strategy = "ROTATE"
  kms_key_id                 = aws_kms_key.this.arn
}

resource "aws_elasticache_replication_group" "valkey-replication-group2" {
  engine                     = "valkey"
  replication_group_id       = "elasticache-group-valkey2"
  description                = "elasticache-group-valkey2"
  node_type                  = "cache.t2.micro"
  cluster_mode               = "enabled"
  automatic_failover_enabled = true
  num_node_groups            = 1
  replicas_per_node_group    = 1
  transit_encryption_enabled = true
  at_rest_encryption_enabled = true
}

resource "aws_elasticache_cluster" "memcached" {
  cluster_id                 = "elasticache-memcached-cluster"
  engine                     = "memcached"
  node_type                  = "cache.t3.micro"
  num_cache_nodes            = 1
  transit_encryption_enabled = true
}
