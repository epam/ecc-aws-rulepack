resource "aws_elasticache_subnet_group" "this" {
  name       = "c7n-269-elasticache-subnet-green"
  subnet_ids = [aws_subnet.this.id, aws_subnet.this1.id]
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id               = "c7n-269-elasticache-redis-cluster-green"
  engine                   = "redis"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 6379
  subnet_group_name        = "c7n-269-elasticache-subnet-green"

  depends_on = [aws_elasticache_subnet_group.this]
}
