resource "aws_elasticache_replication_group" "valkey-replication-group" {
  engine               = "valkey"
  replication_group_id = "elasticache-group-valkey-266-green"
  description          = "elasticache-group-266-green"
  node_type            = "cache.t2.micro"
  cluster_mode         = "enabled"
  automatic_failover_enabled = true
  num_node_groups         = 1
  replicas_per_node_group = 1
  snapshot_retention_limit = 5
}

resource "aws_elasticache_replication_group" "redis-replication-group1" {
  engine               = "redis"
  replication_group_id = "elasticache-group-redis-266-red"
  description          = "elasticache-group-266-green"
  node_type            = "cache.t2.micro"
  cluster_mode         = "enabled"
  automatic_failover_enabled = true
  num_node_groups         = 1
  replicas_per_node_group = 0
}

resource "aws_elasticache_replication_group" "valkey-replication-group1" {
  engine               = "valkey"
  replication_group_id = "elasticache-group-valkey-266-red"
  description          = "elasticache-group-266-green"
  node_type            = "cache.t2.micro"
  cluster_mode         = "enabled"
  automatic_failover_enabled = true
  num_node_groups         = 1
  replicas_per_node_group = 1
  snapshot_retention_limit = 0
}