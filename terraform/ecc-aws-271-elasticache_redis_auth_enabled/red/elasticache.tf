resource "aws_elasticache_replication_group" "this" {
  engine               = "redis"
  replication_group_id = "elasticache-group-redis-271-red"
  description          = "elasticache-group-redis-271-red"
  node_type            = "cache.t2.micro"
  cluster_mode         = "enabled"
  automatic_failover_enabled = true
  num_node_groups         = 1
  replicas_per_node_group = 1
  transit_encryption_enabled    = true
}
