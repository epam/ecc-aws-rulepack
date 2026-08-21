resource "aws_iam_role" "this" {
  name                 = module.naming.resource_prefix.dax

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "dax.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_dax_cluster" "this" {
  cluster_name                     = module.naming.resource_prefix.dax
  iam_role_arn                     = aws_iam_role.this.arn
  node_type                        = "dax.t2.small"
  replication_factor               = 1
  cluster_endpoint_encryption_type = "TLS"

  server_side_encryption {
    enabled = true
  }
}

