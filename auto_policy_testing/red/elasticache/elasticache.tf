# takes about 10 min to deploy

resource "aws_elasticache_replication_group" "this" {
  engine               = "redis"
  replication_group_id = module.naming.resource_prefix.elasticache
  description          = module.naming.resource_prefix.elasticache
  node_type            = "cache.t3.micro"
  num_cache_clusters   = 1
  port                 = 6379
}

