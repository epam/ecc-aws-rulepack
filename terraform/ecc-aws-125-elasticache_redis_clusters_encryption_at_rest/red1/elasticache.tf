# Redis Cluster Mode Enabled
resource "aws_elasticache_replication_group" "this1" {
  engine                     = "redis"
  automatic_failover_enabled  = true
  replication_group_id       = "elasticache-group-125-red1"
  description                = "125_elasticache_group_red1"
  node_type                  = "cache.t2.micro"
  num_node_groups            = 2
  replicas_per_node_group    = 1
  port                       = 6379
  at_rest_encryption_enabled = false
}
