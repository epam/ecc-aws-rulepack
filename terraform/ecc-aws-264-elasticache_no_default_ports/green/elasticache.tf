# it takes 4 minutes to create a cluster and 6 minutes to delete it

resource "aws_elasticache_cluster" "redis" {
  cluster_id               = "elasticache-redis-cluster-264-green"
  engine                   = "redis"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 6666
}

# resource "aws_elasticache_cluster" "valkey" {
#   cluster_id               = "elasticache-memcached-cluster-264-green"
#   engine                   = "valkey"
#   node_type                = "cache.t2.micro"
#   num_cache_nodes          = 1
#   port                     = 6666
# }
# │ Error: creating ElastiCache Cache Cluster (elasticache-cluster-406-red2): operation error ElastiCache: CreateCacheCluster, https response error StatusCode: 400, InvalidParameterValue: This API doesn't support Valkey engine. Please use CreateReplicationGroup API for Valkey cluster creation.