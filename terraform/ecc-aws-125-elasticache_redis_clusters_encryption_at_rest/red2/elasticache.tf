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