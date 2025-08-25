resource "aws_elasticache_cluster" "memcached" {
  cluster_id               = "elasticache-memcached-cluster-264-red"
  engine                   = "memcached"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 2
}

resource "aws_elasticache_cluster" "redis-cluster" {
  cluster_id               = "elasticache-redis-cluster-269-red"
  engine                   = "redis"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
}

resource "aws_elasticache_replication_group" "redis-replication-group" {
  engine               = "redis"
  replication_group_id = "elasticache-group-redis-269-red-2"
  description          = "elasticache-group-269-red"
  node_type            = "cache.t2.micro"
  cluster_mode         = "enabled"
  automatic_failover_enabled = true
  num_node_groups         = 1
  replicas_per_node_group = 1
}

resource "aws_elasticache_replication_group" "valkey-replication-group" {
  engine               = "valkey"
  replication_group_id = "elasticache-group-valkey-269-red"
  description          = "elasticache-group-269-red"
  node_type            = "cache.t2.micro"
  cluster_mode         = "enabled"
  automatic_failover_enabled = true
  num_node_groups         = 1
  replicas_per_node_group = 1
  }
