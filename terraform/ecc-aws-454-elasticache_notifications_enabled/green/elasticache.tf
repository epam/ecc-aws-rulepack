resource "aws_elasticache_cluster" "memcached" {
  cluster_id               = "c7n-454-elasticache-memcached-cluster-green"
  engine                   = "memcached"
  engine_version           = "1.5.16"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  port                     = 11211
  notification_topic_arn   = aws_sns_topic.this.arn
}

resource "aws_sns_topic" "this" {
  name = "sns-topic-454-green"
}
