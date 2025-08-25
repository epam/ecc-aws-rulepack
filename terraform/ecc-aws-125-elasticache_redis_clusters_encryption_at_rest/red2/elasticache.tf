# Redis Cluster Mode Disabled
resource "aws_elasticache_cluster" "this" {
  cluster_id           = "elasticache-cluster-125-red2"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.0"
  port                 = 6379
}


# resource "aws_elasticache_replication_group" "redis-replication-group1" {
#   engine               = "redis"
#   replication_group_id = "elasticache-group-redis-125-red"
#   description          = "elasticache-group-125-red"
#   node_type            = "cache.t2.micro"
#   cluster_mode         = "enabled"
#   automatic_failover_enabled = true
#   num_node_groups         = 1
#   replicas_per_node_group = 1
#   at_rest_encryption_enabled = false
# }

# resource "aws_elasticache_replication_group" "valkey-replication-group1" {
#   engine               = "valkey"
#   replication_group_id = "elasticache-group-valkey-125-red"
#   description          = "elasticache-group-125-red"
#   node_type            = "cache.t2.micro"
#   cluster_mode         = "enabled"
#   automatic_failover_enabled = true
#   num_node_groups         = 1
#   replicas_per_node_group = 1
#   at_rest_encryption_enabled = false
# }